import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/view/Auth/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  final String uid; // User ID

  const ProfileEditPage({super.key, required this.uid});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _displayNameController = TextEditingController();
  File? _pickedImage;
  String? _currentImageUrl; // URL of current profile picture
  bool _isLoading = false;

  bool _isEmailPasswordUser = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Load the user's current data
    _checkSignInMethod();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _displayNameController.text = userData['displayName'] ?? "";
        _currentImageUrl =
            userData['photoURL']; // Fetch the current profile image URL
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Update Firestore with new display name
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'displayName': _displayNameController.text.trim(),
        });

        // If a new image is selected, upload it
        if (_pickedImage != null) {
          String imageUrl = await _uploadImageToStorage();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .update({'photoURL': imageUrl});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfile()));
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _uploadImageToStorage() async {
    String fileName = 'profile_${widget.uid}.jpg';
    Reference storageRef =
        FirebaseStorage.instance.ref().child('users/${widget.uid}/$fileName');
    UploadTask uploadTask = storageRef.putFile(_pickedImage!);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _checkSignInMethod() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<UserInfo> providerData = user.providerData;
      for (UserInfo info in providerData) {
        if (info.providerId == 'password') {
          setState(() {
            _isEmailPasswordUser = true;
          });
        }
      }
    }
  }

  Future<void> _changePassword() async {
    if (_isEmailPasswordUser) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: FirebaseAuth.instance.currentUser!.email!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent.')),
        );
      } catch (e) {
        print("Error changing password: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send password reset email: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1a26), // Set background color
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xff0d1a26),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : _currentImageUrl != null
                                    ? CachedNetworkImageProvider(
                                        _currentImageUrl!)
                                    : const AssetImage(
                                            'assets/images/astronaut stand.png')
                                        as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: _pickImage,
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 28,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: Colors.blueAccent,
                              iconSize: 28,
                              splashRadius: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Display Name Field
                    TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        prefixIcon: Icon(Icons.edit),
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.white70),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Display name cannot be empty';
                        }
                        return null;
                      },
                    ),

                    // Change Password Button (only visible for email/password users)
                    if (_isEmailPasswordUser)
                      ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                    // Save Button
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
