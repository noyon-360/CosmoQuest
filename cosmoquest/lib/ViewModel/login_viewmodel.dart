import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Utils/SnackbarUtil.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/Utils/utils.dart';
import 'package:cosmoquest/ViewModel/UserProfileViewModel.dart';
import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Auth/Congratulatory.dart';
import 'package:cosmoquest/view/Auth/EmailVerification.dart';
import 'package:cosmoquest/view/Game/levels_map.dart';
import 'package:cosmoquest/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserProfileViewModel _profileViewModel = UserProfileViewModel();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  bool _obscureText = true;

  bool get obscureText => _obscureText;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loginWithEmailPassword(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (formKey.currentState!.validate()) {
      _setLoading(true);
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        User? user = userCredential.user;



        if (user != null) {
          final userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          String photoUrl = Utils.generateImageUrl(emailController.text);
          String userName = Utils.generateRandomName(user.uid);

          if (user.emailVerified) {
            if (!userDoc.exists) {
              SnackBarUtil.showSnackbar(
                  context, "Account Created Successfully");
              // Create new Firestore document
              await _firestore.collection('users').doc(user.uid).set({
                'email': user.email,
                'displayName': userName,
                'photoURL': photoUrl,
                'created_at': DateTime.now(),
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => CongratulatoryPage(photoUrl: photoUrl, userName: userName)),
                    (route) => false,
              );
            }
            await _profileViewModel.fetchUserData(user.uid);
            await _profileViewModel.syncLocalProgress();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarHome()));
          } else {
            SnackBarUtil.showSnackbar(context, "Please verify your email.");
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const EmailVerificationScreen()));
          }
        }
      } on FirebaseAuthException catch (e) {
        print("error : $e\n\n");
        if (e.code ==
            '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
          SnackBarUtil.showSnackbar(
              context, "Incorrect password. Please try again.");
        } else if (e.code == 'user-not-found') {
          SnackBarUtil.showSnackbar(context, "No user found with this email.");
        } else if (e.code ==
            'Logging in as ${emailController.text} with empty reCAPTCHA token') {
          SnackBarUtil.showSnackbar(context, "No user found with this email.");
        } else {
          SnackBarUtil.showSnackbar(context, "Login failed. Please try again.");
        }
      } finally {
        _setLoading(false);
      }
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    String email = emailController.text;

    if (email.isEmpty || !EmailValidator.validate(email)) {
      SnackBarUtil.showSnackbar(context, "Please enter a valid email");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      SnackBarUtil.showSnackbar(
          context, "Password reset email sent. Please check your inbox.");
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      SnackBarUtil.showSnackbar(
          context, "Failed to send password reset email. Please try again.");
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    _setLoading(true);

    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // await _auth.signInWithCredential(credential);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        await _profileViewModel.fetchUserData(user.uid);
        await _profileViewModel.syncLocalProgress();

        if (userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const BottomNavigationBarHome()));
        }

        if (!userDoc.exists) {
          SnackBarUtil.showSnackbar(context, "Created a new account");
          // Create new Firestore document
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'created_at': DateTime.now(),
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => CongratulatoryPage(photoUrl: user.photoURL.toString(), userName: user.displayName.toString())));
        }
        // else{
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavigationBarHome()));
        // }
      }
      // Navigate to LevelScreen after successful Google login
    } catch (e) {
      throw Exception("Error logging in with Google: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    UserProgressLocalStore userProgressLocalStore = UserProgressLocalStore();
    userProgressLocalStore.resetProgress();

    Apis.auth.signOut();
    GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Home()));
    notifyListeners();
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Please enter your email";
    } else if (!EmailValidator.validate(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }
}
