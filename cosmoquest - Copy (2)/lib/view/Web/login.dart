import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/view/Web/Dashboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String inputUsername = _usernameController.text.trim();
    String inputPassword = _passwordController.text.trim();

    try {
      // Fetch the 'admin' collection from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .get();

      bool isAuthenticated = false;

      // Loop through the documents in the 'admin' collection
      for (var doc in querySnapshot.docs) {
        var adminData = doc.data() as Map<String, dynamic>;

        if (adminData['username'] == inputUsername &&
            adminData['password'] == inputPassword) {
          isAuthenticated = true;
          break;
        }
      }

      if (isAuthenticated) {
        // Credentials match, navigate to the Dashboard page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        // Incorrect credentials
        _showErrorDialog('Incorrect username or password.');
      }
    } catch (error) {
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
