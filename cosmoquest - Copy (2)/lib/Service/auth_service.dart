import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String email) async {
    try {
      await _firestore.collection('user').add({
        'name': email,
      });
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }
}
