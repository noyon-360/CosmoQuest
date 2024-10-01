import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/Model/UserModel.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Service/user_service.dart';
import 'package:cosmoquest/Utils/SnackbarUtil.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/Utils/date_checker.dart';
import 'package:cosmoquest/ViewModel/Leaderborad/leaderboard_view_model.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:cosmoquest/view/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class UserProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserProgressFireStore _userProgressFireStore = UserProgressFireStore();
  final UserProgressLocalStore _userProgressLocalStore = UserProgressLocalStore();
  final UserService _userService = UserService();

  UserModel? userModel;
  bool isLoading = true;

  int userLevel = 0;
  List<int> userRatings = List.filled(20, 0);

  File? _pickedFile;
  bool isUploading = true;

  Map<String, dynamic>? _ratingsMap; // Storing the ratings map fetched from Firestore
  Map<String, dynamic>? _score;

  // Display ratings in the UI
  Map<String, dynamic>? get userRatingsMap => _ratingsMap;
  Map<String, dynamic>? get userScore => _score;


  Future<void> fetchUserData(String uid) async {
    try {
      // Fetch the user document from Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        userModel = UserModel.fromFirestore(userDoc.data()!);
      }

      // Fetch the user level from Firestore (Assuming user level is stored separately)
      userLevel = await _userProgressFireStore.getLevel();

      // Fetch the user's ratings and scores from the 'user_progress' sub-collection
      final userProgressDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('user_progress')  // Assuming the progress is stored here
          .doc('details')  // Assuming details contains the progress info
          .get();

      if (userProgressDoc.exists) {
        // Fetching the 'ratings' field, which is a map of level to rating and score
        Map<String, dynamic> progressData = userProgressDoc.data()!;
        if (progressData.containsKey('ratings')) {
          _ratingsMap = progressData['ratings'] as Map<String, dynamic>;

          // Extract scores from the ratings map
          userRatings = _ratingsMap!.entries
              .map((entry) => entry.value['score'] as int)
              .toList();

          print("User Ratings: $progressData");
        } else {
          print("No ratings found");
        }
      } else {
        print("No user progress document found");
      }

      await syncLocalProgress();
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading = false;
      notifyListeners();  // Notify the view of data changes
    }
  }

  Map<String, List<Map<String, dynamic>>> leaderboardData = {};

  int currentPosition = 0;

  bool hasError = false;
  String errorMessage = '';


  Future<void> fetchUserPositionInLeaderboard(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      final usersDocs = usersSnapshot.docs;

      final List<Map<String, dynamic>> allTimeScores = [];

      // Aggregate scores for all users
      for (var doc in usersDocs) {
        final userData = doc.data();
        final userId = doc.id;
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection("user_progress")
            .doc("details");

        final ratingSnapshot = await userDocRef.get();
        final ratings = ratingSnapshot.data()?['ratings'] ?? {};
        int totalScore = 0;

        if (ratings is Map<String, dynamic>) {
          ratings.forEach((_, ratingData) {
            int score = ratingData['score'];
            totalScore += score;
          });
        }

        allTimeScores.add({
          'userId': userId,
          'score': totalScore,
          'displayName': userData['displayName'] ?? 'Unknown',
          'photoURL': userData['photoURL'] ?? '',
        });
      }

      // Sort scores and find the user's position
      allTimeScores.sort((a, b) => b['score'].compareTo(a['score']));
      currentPosition = allTimeScores.indexWhere((user) => user['userId'] == userId) + 1;

      isLoading = false;
      hasError = false;
      notifyListeners();
    } catch (error) {
      hasError = true;
      errorMessage = 'Error fetching user position: $error';
      isLoading = false;
      notifyListeners();
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

  // Future<void> pickVideo(BuildContext context) async {

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
  // }


  // Future<String> uploadVideoToStorage(File videoFile, String path, String fileName) async {
  //   try {
  //     TaskSnapshot snapshot = await FirebaseStorage.instance.ref(path).child('video').putFile(videoFile);
  //
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     return downloadUrl;
  //   } catch (e){
  //     return "";
  //   }
  // }


  Future<String> uploadImageToStorage(File imageFile, String path, String fileName) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref(path).child('profile').child('fileName').putFile(imageFile);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e){
      return "";
    }
  }

  // Future<String> getVideoUrl(String path) async {
  //   try {
  //     // Reference the file in Firebase Storage
  //     String downloadURL = await FirebaseStorage.instance.ref('/game/level_1/').getDownloadURL();
  //     return downloadURL;
  //   } catch (e) {
  //     print("Error fetching video URL: $e");
  //     return '';
  //   }
  // }


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
