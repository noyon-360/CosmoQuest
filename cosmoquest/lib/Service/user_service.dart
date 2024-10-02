import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';

class UserService {
  // Fetch user profile info from 'users' collection
  static Future<Map<String, dynamic>> getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception('User document does not exist');
      }
    } else {
      throw Exception('No user logged in');
    }
  }

  // Fetch user progress info from 'user_progress' collection
  Future<Map<String, dynamic>> getUserProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userProgressDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('user_progress')
          .doc('details')
          .get();

      if (userProgressDoc.exists && userProgressDoc.data() != null) {
        return userProgressDoc.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if no progress is found
      }
    } else {
      throw Exception('No user logged in');
    }
  }

  // Combine user info and progress into a single map
  Future<Map<String, dynamic>> getCompleteUserProfile() async {
    try {
      final userInfo = await getUserInfo();
      final userProgress = await getUserProgress();

      // Combine both maps into one
      final completeProfile = {...userInfo, ...userProgress};
      return completeProfile;
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  static Future<void> updateUserProfile(
      String name,
      XFile? imageFile,
      String password,
      ) async {
    // Update the user's profile here
    // For example, using Firebase Authentication and Firestore:
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      if (imageFile != null) {
        await user.updatePhotoURL(await uploadImage(imageFile));
      }
      await user.updatePassword(password);
    }
  }

  static Future<String> uploadImage(XFile imageFile) async {
    // Upload the image to a storage service like Firebase Storage
    // For example:
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("images/${DateTime.now().millisecondsSinceEpoch}");
    await imageRef.putFile(imageFile as File);
    return await imageRef.getDownloadURL();
  }


}
