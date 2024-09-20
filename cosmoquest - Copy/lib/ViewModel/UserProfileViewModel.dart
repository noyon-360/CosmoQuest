import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/Model/UserModel.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Utils/SnackbarUtil.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:cosmoquest/view/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


class UserProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserProgressFireStore _userProgressFireStore = UserProgressFireStore();
  final UserProgressLocalStore _userProgressLocalStore = UserProgressLocalStore();

  UserModel? userModel;
  bool isLoading = true;

  int userLevel = 1;
  List<int> userRatings = List.filled(20, 0);

  File? _pickedFile;
  bool isUploading = true;

  Future<void> fetchUserData(String uid) async {
    try {
      // Fetch user data from Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userModel = UserModel.fromFirestore(userDoc.data()!);
      }

      userLevel = await _userProgressFireStore.getLevel();
      userRatings = await _userProgressFireStore.getRating();


    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading = false;
      notifyListeners(); // Notify the view of data changes
    }
  }

  Future<void> pickImage(BuildContext context, String uid) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null){
      if (pickedFile.path.endsWith('.jpg') || pickedFile.path.endsWith('.jpeg') || pickedFile.path.endsWith('.png')){
        String fileName = pickedFile.name;

        _pickedFile = File(pickedFile.path);

        String image = await uploadImageToStorage(_pickedFile!, 'users/${Apis.user.uid.toString()}/', fileName);

        try{
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'photoURL': image,
          }).then((value){
            SnackBarUtil.showSnackbar(context, "Profile Upload successfully");
          });
        }
        catch(e){
          SnackBarUtil.showSnackbar(context, "Can't add the picture");
        }

        await fetchUserData(Apis.user.uid.toString());

        isUploading = false;
        notifyListeners();
      }
    }
  }

  Future<void> pickVideo(BuildContext context) async {

    // Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen()));
    // final XFile? pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    //
    // if(pickedFile != null){
    //   if(pickedFile.path.endsWith(".mp4") || pickedFile.path.endsWith('.mov') || pickedFile.path.endsWith('.avi')){
    //     String fileName = pickedFile.name;
    //     // print(fileName);
    //     _pickedFile = File(pickedFile.path);
    //
    //     String video = await uploadVideoToStorage(_pickedFile!, 'game/', fileName);
    //
    //     print(video);
    //
    //     // Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen()));
    //
    //
    //   }
    // }
  }


  Future<String> uploadVideoToStorage(File videoFile, String path, String fileName) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref(path).child('video').putFile(videoFile);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e){
      return "";
    }
  }


  Future<String> uploadImageToStorage(File imageFile, String path, String fileName) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref(path).child('profile').child('fileName').putFile(imageFile);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e){
      return "";
    }
  }

  Future<String> getVideoUrl(String path) async {
    try {
      // Reference the file in Firebase Storage
      String downloadURL = await FirebaseStorage.instance.ref('/game/level_1/').getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error fetching video URL: $e");
      return '';
    }
  }


  Future<void> syncLocalProgress() async {
    await _userProgressLocalStore.saveLevel(userLevel);
    for (int i = 0; i < userRatings.length; i++){
      await _userProgressLocalStore.saveRating(i, userRatings[i]);
    }
  }

  Future<void> logout(BuildContext context) async {
    UserProgressLocalStore userProgressLocalStore = UserProgressLocalStore();
    userProgressLocalStore.resetProgress();

    Apis.auth.signOut();
    GoogleSignIn().signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
    notifyListeners();
  }

}
