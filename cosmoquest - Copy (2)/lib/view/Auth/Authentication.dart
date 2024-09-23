import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Auth/signup.dart';
import 'package:cosmoquest/view/Game/levels_map.dart';
import 'package:cosmoquest/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationCheck extends StatelessWidget {
  const AuthenticationCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator
        } else if (snapshot.hasData) {
          return const BottomNavigationBarHome(); // If user is authenticated, go to LevelScreen
        } else {
          return const Home(); // If not authenticated, go to SignUpScreen
        }
      },
    );
  }
}
