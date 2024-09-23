import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgressLocalStore {
  static const String _keyLevel = 'user_level';
  static const String _keyRating = 'level_rating';

  Future<void> saveLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLevel, level);
  }

  Future<int> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLevel) ?? 0;
  }

  Future<void> saveRating(int level, int rating) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> ratings = prefs.getStringList(_keyRating) ?? List.filled(20, '0');
    ratings[level] = rating.toString();
    await prefs.setStringList(_keyRating, ratings);
  }

  Future<List<int>> getRating() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rating = prefs.getStringList(_keyRating) ?? List.filled(20, '0');

    return rating.map(int.parse).toList();
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLevel, 0);
    await prefs.setStringList(_keyRating, List.filled(20, '0'));
  }
}

class UserProgressFireStore {
  static const String _collectionName = 'user_progress';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's Firestore document
  Future<DocumentReference> _getUserDoc() async {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).collection(_collectionName).doc("details");
    } else {
      throw Exception('No user logged in');
    }
  }

  // Save user level to Firestore
  Future<void> saveLevel(int level) async {
    final userDoc = await _getUserDoc();
    await userDoc.set({'level': level}, SetOptions(merge: true));
  }

  // Get user level from Firestore
  Future<int> getLevel() async {
    final userDoc = await _getUserDoc();
    final snapshot = await userDoc.get();

    // Cast snapshot data to a Map<String, dynamic>
    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['level'] ?? 0;
    } else {
      return 0;
    }
  }


  Future<void> saveRating(int level, int rating) async {
    final userDoc = await _getUserDoc();
    final snapshot = await userDoc.get();

    // Cast snapshot data to Map<String, dynamic> if it exists
    Map<String, dynamic> ratingMap = {};
    if (snapshot.exists && snapshot.data() != null) {
      ratingMap = snapshot.data() as Map<String, dynamic>;  // Casting to Map<String, dynamic>
      ratingMap = ratingMap['ratings'] ?? {};  // Get the 'ratings' field, if exists
    }

    // Update the rating for the specified level
    ratingMap[level.toString()] = rating;

    // Save the updated ratings back to Firestore
    await userDoc.set({'ratings': ratingMap}, SetOptions(merge: true));
  }

  Future<List<int>> getRating() async {
    final userDoc = await _getUserDoc();
    final snapshot = await userDoc.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;  // Casting to Map<String, dynamic>
      Map<String, dynamic> ratingMap = data['ratings'] ?? {};

      // Convert the ratings map to a List<int>
      List<int> ratings = List.generate(20, (index) => int.parse(ratingMap[index.toString()]?.toString() ?? '0'));
      return ratings;
    } else {
      // Return a default list if no data is found
      return List.filled(20, 0);
    }
  }

  // Reset user progress in Firestore
  Future<void> resetProgress() async {
    final userDoc = await _getUserDoc();
    await userDoc.set({
      'level': 0,
      'ratings': List.filled(20, 0).asMap().map((key, value) => MapEntry(key.toString(), value))
    });
  }
}
