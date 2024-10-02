import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Utils/SnackbarUtil.dart';
import 'package:cosmoquest/Utils/utils.dart';
import 'package:cosmoquest/ViewModel/UserProfileViewModel.dart';
import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Auth/Congratulatory.dart';
import 'package:cosmoquest/view/Auth/LoginScreen.dart';
import 'package:cosmoquest/view/Game/levels_map.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final UserProgressFireStore _userProgressFireStore = UserProgressFireStore();
  final UserProfileViewModel _profileViewModel = UserProfileViewModel();

  bool _obscureText = true;

  bool get obscureText => _obscureText;

  bool _confirmObscureText = true;

  bool get confirmObscureText => _confirmObscureText;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _confirmObscureText = !confirmObscureText;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //

  // Email & Password Sign Up
  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          await _auth.signOut(); //temp

          // Generate a 9-letter display name using the user UID
          // String displayName = Utils.generateRandomName(user.uid);
          // String photoURL = Utils.generateImageUrl(email);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "A verification email has been sent. Please verify and log in.")));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));

          // Save user info in Firestore
          // await _firestore.collection('users').doc(user.uid).set({
          //   'email': user.email,
          //   'displayName': displayName,
          //   'photoURL': photoURL,
          //   'created_at': DateTime.now(),
          // });
        }
      } catch (e) {
        print(e);
        if (e.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          SnackBarUtil.showSnackbar(
              context, "The email address is already in use.");
        }
      }
    }
  }



  Future<void> _resetLevels() async {
    final userProgressLocalStore = UserProgressLocalStore();
    final userProgressFireStore = UserProgressFireStore();

    await userProgressLocalStore
        .resetProgress(); // Implement this method in UserProgress to reset user data
    await userProgressFireStore.resetProgress();
    //
    // setState(() {
    //   // Unlock only the first level, lock all other levels
    //   levelLocks = List.generate(20, (index) => index != 0); // Unlock the first level (index 0) only
    // });
    //
    // SnackBarUtil.showSnackbar(context, 'Levels have been reset. Only the first level is unlocked.');
  }

  // Google Sign In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Google and Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          _profileViewModel.syncLocalProgress();
          SnackBarUtil.showSnackbar(context, "Already have an account");

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const BottomNavigationBarHome()));
        }

        if (!userDoc.exists) {
          // Create new Firestore document
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'created_at': DateTime.now(),
          });

          await _userProgressFireStore.resetProgress();
          // Navigate to LevelScreen after successful sign-in
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => CongratulatoryPage(photoUrl: user.photoURL.toString(), userName: user.displayName.toString())));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
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
    } else if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty || value != passwordController.text) {
      return "Password is not match"; // Fails if the passwords don't match
    }
    return null;
  }
}
