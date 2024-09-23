import 'dart:async';

import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;

    if(user != null){
      isEmailVerified = user!.emailVerified;

      if(!isEmailVerified){
        timer = Timer.periodic(const Duration(seconds: 5), (timer) async{
          await user!.reload();
          setState(() {
            isEmailVerified = user!.emailVerified;
          });

          if (isEmailVerified){
            timer.cancel();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const BottomNavigationBarHome()));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isEmailVerified ? const Text("Email verified! Redirecting...") : const Text('Please verify your email.'),
      ),
    );
  }
}
