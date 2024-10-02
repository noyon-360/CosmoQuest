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

    List<String> ratings =
        prefs.getStringList(_keyRating) ?? List.filled(20, '0');
    ratings[level] = rating.toString();
    await prefs.setStringList(_keyRating, ratings);
  }

  Future<List<int>> getRating() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rating =
        prefs.getStringList(_keyRating) ?? List.filled(20, '0');

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
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection(_collectionName)
          .doc("details");
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
    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['level'] ?? 0;
    } else {
      return 0;
    }
  }

  // Save user rating
  Future<void> saveRatingAndScore(int level, int rating, int score) async {
    final userDoc = await _getUserDoc();
    final snapshot = await userDoc.get();
    Map<String, dynamic> ratingMap = {};
    if (snapshot.exists && snapshot.data() != null) {
      ratingMap = snapshot.data() as Map<String, dynamic>;
      ratingMap = ratingMap['ratings'] ?? {};
    }
    ratingMap[level.toString()] = {
      'rating': rating,
      'score' : score,
      'date': DateTime.now().toIso8601String(),
    };
    await userDoc.set({'ratings': ratingMap}, SetOptions(merge: true));
  }

  // Future<List<Map<String, dynamic>>> getAllRatings() async {
  //   final usersCollection = _firestore.collection('users');
  //   final ratingsList = <Map<String, dynamic>>[];
  //
  //   final querySnapshot = await usersCollection.get();
  //   for (final userDoc in querySnapshot.docs) {
  //     final userRatingsDoc = userDoc.reference .collection(_collectionName).doc("details");
  //     final snapshot = await userRatingsDoc.get();
  //     if (snapshot.exists && snapshot.data() != null) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       final ratingsMap = data['ratings'] ?? {};
  //       final user = {
  //         'name': userDoc.get('name'),
  //         'photoUrl': userDoc.get('photoUrl'),
  //       };
  //       ratingsMap.forEach((level, ratingData) {
  //         ratingData['user'] = user;
  //       });
  //       ratingsList.add(ratingsMap);
  //     }
  //   }
  //
  //   return ratingsList;
  // }

  // // Save score for a specific level
  // Future<void> saveScore(int level, int score) async {
  //   final userDoc = await _getUserDoc();
  //   final snapshot = await userDoc.get();
  //   Map<String, dynamic> scoreMap = {};
  //   if (snapshot.exists && snapshot.data() != null) {
  //     scoreMap = snapshot.data() as Map<String, dynamic>;
  //     scoreMap = scoreMap['scores'] ?? {};
  //   }
  //   scoreMap[level.toString()] = {
  //     'score': score,
  //     'date': DateTime.now().toIso8601String(),
  //   };
  //   await userDoc.set({'scores': scoreMap}, SetOptions(merge: true));
  // }

  // Get average ratings based on the specified period
  // Future<List<Map<String, dynamic>>> getAverageRatings(String period) async {
  //   final userDoc = await _getUserDoc();
  //   final snapshot = await userDoc.get();
  //
  //   if (snapshot.exists && snapshot.data() != null) {
  //
  //     final data = snapshot.data() as Map<String, dynamic>;
  //     Map<String, dynamic> ratingMap = data['ratings'] ?? {};
  //     List<double> averageRatings = List.filled(20, 0);
  //     List<int> counts = List.filled(20, 0);
  //     DateTime now = DateTime.now();

      // print(ratingMap);

      // for (var entry in ratingMap.entries){
      //   print(entry.key);
      // }

      // for (var entry in ratingMap.values) {
      //
      //   int level = int.parse(entry.key);
      //   print("level\n");
      //   List<dynamic> ratings = entry.value;
      //
      //   for (var ratingEntry in ratings) {
      //     DateTime ratingDate = DateTime.parse(ratingEntry['date']);
      //     int rating = ratingEntry['rating'];
      //     bool isInTimePeriod = false;
      //
      //     if (period == 'all_time') {
      //       isInTimePeriod = true;
      //     } else if (period == 'today') {
      //       isInTimePeriod = ratingDate.year == now.year &&
      //           ratingDate.month == now.month &&
      //           ratingDate.day == now.day;
      //     } else if (period == 'weekly') {
      //       isInTimePeriod = ratingDate.isAfter(now.subtract(Duration(days: 7)));
      //     }
      //     if (isInTimePeriod) {
      //       averageRatings[level] += rating;
      //       counts[level] += 1;
      //     }
      //   }
      // }
  //     return List.generate(20, (index) {
  //       return {
  //         'level': index,
  //         'averageRating': counts[index] > 0 ? averageRatings[index] / counts[index] : 0,
  //       };
  //     });
  //   } else {
  //     return List.generate(20, (_) => {'level': 0, 'averageRating': 0});
  //   }
  // }

  // Get all ratings for the user
  Future<List<Map<String, dynamic>>> getRating() async {
    final userDoc = await _getUserDoc();
    final snapshot = await userDoc.get();
    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> ratingMap = data['ratings'] ?? {};
      List<Map<String, dynamic>> ratings = List.generate(20, (index) {
        return ratingMap[index.toString()] != null
            ? {
          'rating': ratingMap[index.toString()]['rating'] ?? 0,
          'date': ratingMap[index.toString()]['date'] ?? '',
        }
            : {
          'rating': 0,
          'date': '',
        };
      });
      return ratings;
    } else {
      return List.generate(20, (_) => {'rating': 0, 'date': ''});
    }
  }

  // Reset user progress in Firestore
  Future<void> resetProgress() async {
    final userDoc = await _getUserDoc();
    await userDoc.set({
      'level': 0,
      'ratings': List.filled(20, 0)
          .asMap()
          .map((key, value) => MapEntry(key.toString(), value)),
      'scores': List.filled(20, 0)
          .asMap()
          .map((key, value) => MapEntry(key.toString(), value))
    });
  }
}

