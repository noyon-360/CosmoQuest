import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cosmoquest/Utils/date_checker.dart';

class LeaderboardViewModel extends ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> leaderboardData = {
    'allTime': [],
    'today': [],
    'weekly': []
  };

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  // Fetch leaderboard data
  Future<void> fetchLeaderboardData() async {
    try {
      isLoading = true;
      notifyListeners(); // Notify listeners that loading has started

      final usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();
      final usersDocs = usersSnapshot.docs;

      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));

      // Maps to hold unique users and their aggregated scores for each leaderboard
      final Map<String, Map<String, dynamic>> allTimeMap = {};
      final Map<String, Map<String, dynamic>> todayMap = {};
      final Map<String, Map<String, dynamic>> weeklyMap = {};

      final futures = <Future<void>>[];

      for (var doc in usersDocs) {
        final userData = doc.data();
        final userId = doc.id;
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection("user_progress")
            .doc("details");

        futures.add(userDocRef.get().then((ratingSnapshot) {
          final ratings = ratingSnapshot.data()?['ratings'] ?? {};
          final userLevel = ratingSnapshot.data()?['level'] ?? 0;
          final user = {
            'name': userData['displayName'] ?? 'Unknown',
            'photoUrl': userData['photoURL'] ?? '',
            'level': userLevel, // Include level in user data
          };

          if (ratings is Map<String, dynamic>) {
            int totalScore = 0;

            ratings.forEach((level, ratingData) {
              int score = ratingData['score'];
              totalScore += score;
              String userUpLevel = (int.parse(userLevel.toString()) + 1).toString();

              final date = DateTime.parse(ratingData['date']);

              // Process today's leaderboard
              if (date.isToday()) {
                if (!todayMap.containsKey(userId)) {
                  todayMap[userId] = {
                    'user': user,
                    'score': score,
                    'level': userUpLevel,
                  };
                } else {
                  todayMap[userId]!['score'] += score;
                }
              }
              // Process weekly leaderboard
              if (date.isAfter(startOfWeek) && date.isBefore(endOfWeek)) {
                if (!weeklyMap.containsKey(userId)) {
                  weeklyMap[userId] = {
                    'user': user,
                    'score': score,
                    'level': userUpLevel,
                  };
                } else {
                  weeklyMap[userId]!['score'] += score;
                }
              }

              // Process all-time leaderboard
              if (!allTimeMap.containsKey(userId)) {
                allTimeMap[userId] = {
                  'user': user,
                  'score': totalScore,
                  'level': userUpLevel,
                };
              } else {
                allTimeMap[userId]!['score'] += score;
              }
            });
          }
        }));
      }

      await Future.wait(futures);

      // Convert maps to lists and sort them by score
      leaderboardData = {
        'allTime': allTimeMap.values.toList()
          ..sort((a, b) => b['score'].compareTo(a['score'])),
        'today': todayMap.values.toList()
          ..sort((a, b) => b['score'].compareTo(a['score'])),
        'weekly': weeklyMap.values.toList()
          ..sort((a, b) => b['score'].compareTo(a['score'])),
      };

      isLoading = false;
      hasError = false;
      notifyListeners(); // Notify listeners that data has been fetched
    } catch (error) {
      hasError = true;
      errorMessage = 'Error fetching leaderboard data: $error';
      isLoading = false;
      notifyListeners(); // Notify listeners about the error
    }
  }
}
