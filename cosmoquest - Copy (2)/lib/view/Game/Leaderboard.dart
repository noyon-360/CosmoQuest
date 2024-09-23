import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/view/Auth/Profile.dart';
import 'package:cosmoquest/view/UsersDetails/users_profile.dart';
import 'package:flutter/material.dart';


class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> usersData = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _fetchUsersData();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _fetchUsersData() async {
    try {
      // Fetch the list of users
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> fetchData = [];

      // Loop through each user's document to fetch their progress details
      for (var doc in snapshot.docs) {
        String uid = doc.id;
        String displayName = doc['displayName'];
        String photoUrl = doc['photoURL'];


        try {
          // Get the user's progress details from the subcollection
          DocumentSnapshot progressSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('user_progress')
              .doc('details')
              .get();

          if (progressSnapshot.exists) {
            // If the details document exists, retrieve the level
            var level = progressSnapshot['level'];

            fetchData.add({
              'uid': uid,
              'name': displayName,
              'photoUrl' : photoUrl,
              'level': level,
            });
          } else {
            fetchData.add({
              'uid': uid,
              'name': displayName,
              'photoUrl' : photoUrl,
              'level': 0, // Default level if no data
            });
          }
        } catch (e) {
          fetchData.add({
            'uid': uid,
            'name': displayName,
            'photoUrl' : photoUrl,
            'level': 0, // Default for users without progress data
          });
        }
      }

      // Sort users by their level (descending)
      fetchData.sort((a, b) => b['level']?.compareTo(a['level']) ?? 0);
      setState(() {
        usersData = fetchData; // Update the state with fetched data
      });

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.share))],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Today"),
            Tab(text: "Week"),
            Tab(text: "Month"),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Background/account.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3), // Dark overlay for better text contrast
            ),
          ),
          Column(
            children: [
              // Top 3 section
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (usersData.length > 1)
                      _buildTopUser(context, "2nd", Colors.grey, usersData[1]['photoUrl'] as String?, usersData[1]['name'] as String?, usersData[1]['level']?.toString()),
                    if (usersData.isNotEmpty)
                      _buildTopUser(context, "1st", Colors.amber, usersData[0]['photoUrl'] as String?, usersData[0]['name'] as String?, usersData[0]['level']?.toString(), bigger: true),
                    if (usersData.length > 2)
                      _buildTopUser(context, "3rd", Colors.brown, usersData[2]['photoUrl'] as String?, usersData[2]['name'] as String?, usersData[2]['level']?.toString()),
                  ],
                ),
              ),

              // Tab views for other scores
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScoreList(usersData.skip(3).toList()), // Skip the top 3 users for the "Today" tab
                    _buildScoreList(usersData.skip(3).toList()), // Use the same for "Week" for now
                    _buildScoreList(usersData.skip(3).toList()), // Same for "Month" for now
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for top users
Widget _buildTopUser(BuildContext context, String rank, Color color, String? imageUrl, String? displayName, String? level, {bool bigger = false}) {
  return InkWell(
    onTap: () {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => UsersProfile(photoUrl: imageUrl.toString(), name: displayName.toString(), email: "", level: int(level), ratings: ratings)));
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: bigger ? 30 : 20,
          backgroundColor: color,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null, // Check for null before using
        ),
        const SizedBox(height: 8),
        Text(
          displayName ?? "Unknown User", // Provide a fallback for display name
          style: TextStyle(
            fontSize: bigger ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Level: ${level ?? 0}", style: const TextStyle(color: Colors.white)), // Provide a default level if null
      ],
    ),
  );
}

// Placeholder for scores list
// Placeholder for scores list beyond the top 3 users
Widget _buildScoreList(List<Map<String, dynamic>> remainingUsers) {
  return ListView.builder(
    itemCount: remainingUsers.length, // Number of users after the top 3
    itemBuilder: (context, index) {
      var user = remainingUsers[index];
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: user['photoUrl'] != null ? NetworkImage(user['photoUrl']) : null,
          backgroundColor: Colors.blueGrey,
          child: user['photoUrl'] == null
              ? Text(
            user['name'][0].toUpperCase(), // Use the first letter of the name as fallback
            style: const TextStyle(color: Colors.white),
          )
              : null,
        ),
        onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => UsersProfile(level: level, ratings: ratings)))
        },
        title: Text(user['name'] ?? "Unknown User"),
        subtitle: Text("Level: ${user['level'] ?? 0}"), // Display level of user
        trailing: Text("#${index + 4}"), // Adjust the rank number after the top 3
      );
    },
  );
}

