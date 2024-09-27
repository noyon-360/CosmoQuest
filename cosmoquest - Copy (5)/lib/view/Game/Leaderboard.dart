import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> usersData = [];
  TabController? _tabController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsersData();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchUsersData() async {
    try {
      // Fetch the list of users
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

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
              'photoUrl': photoUrl,
              'level': level,
            });
          } else {
            fetchData.add({
              'uid': uid,
              'name': displayName,
              'photoUrl': photoUrl,
              'level': 0, // Default level if no data
            });
          }
        } catch (e) {
          fetchData.add({
            'uid': uid,
            'name': displayName,
            'photoUrl': photoUrl,
            'level': 0, // Default for users without progress data
          });
        }
      }

      // Sort users by their level (descending)
      fetchData.sort((a, b) => b['level']?.compareTo(a['level']) ?? 0);
      setState(() {
        usersData = fetchData;
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String getRankImage(int rank) {
    switch (rank) {
      case 1:
        return 'assets/Icons/crown.png';
      case 2:
        return 'assets/Icons/Badges-space.png';
      case 3:
        return 'assets/Icons/Badges-reach-moon.png';
      default:
        return 'assets/Icons/Badges-moon.png';
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
      body: Stack(
        children: [
          Container(
            color: Colors.white.withOpacity(0.9),
          ),
          if(isLoading)
            Center(child: CircularProgressIndicator()),
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/Background/Leaderboard back 2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Leaderboard", style: TextStyle(fontSize: 24),),
                              Icon(Icons.share)
                            ],
                          ),
                        ),
                        TabBar(
                          dividerColor: Colors.transparent,
                          controller: _tabController,
                          tabs: const [
                            Tab(text: "All Time"),
                            Tab(text: "Weekly"),

                          ],
                          labelColor: Colors.white,
                          // Text color for selected tabs
                          unselectedLabelColor: Colors.white70,
                          // Text color for unselected tabs
                          indicatorColor: Colors.yellow,
                          // Indicator color
                          indicatorWeight: 2.0,
                          indicatorSize: TabBarIndicatorSize.label,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 2nd
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [

                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20)),
                                          color: Color(0xFF202236)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(usersData[1]['name']!.toString()),
                                          Text(usersData[1]['level']!.toString())

                                        ],
                                      ),
                                    ),
                                    if (usersData.length > 1)
                                      Positioned(
                                        top: -30,
                                        child: _buildTopUser(
                                          context,
                                          2,
                                          Colors.grey,
                                          usersData[1]['photoUrl'] as String?,
                                          // usersData[1]['name'] as String?,
                                          // usersData[1]['level']?.toString()
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            // 1st
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [

                                    Container(
                                      width: 100,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight:
                                                  Radius.circular(30)),
                                          color: Color(0xFF252A40)),
                                    ),
                                    if (usersData.length > 1)
                                      Positioned(
                                        top: -80,
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/Icons/crown.png",
                                              width: 60,
                                            ),
                                            _buildTopUser(
                                              context,
                                              2,
                                              Colors.grey,
                                              usersData[0]['photoUrl']
                                                  as String?,
                                              // usersData[1]['name'] as String?,
                                              // usersData[1]['level']?.toString()
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            // 3rd
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight:
                                                  Radius.circular(20)),
                                          color: Color(0xFF1D2236)),

                                    ),
                                    if (usersData.length > 1)
                                      Positioned(
                                        top: -30,
                                        child: _buildTopUser(
                                          context,
                                          2,
                                          Colors.grey,
                                          usersData[2]['photoUrl'] as String?,
                                          // usersData[1]['name'] as String?,
                                          // usersData[1]['level']?.toString()
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScoreList(usersData.skip(3).toList()), // Galactic Day
                    _buildScoreList(usersData.skip(3).toList()), // Star Week
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
  Widget _buildTopUser(
      BuildContext context, int rank, Color color, String? imageUrl,
      {bool bigger = false}) {


    return InkWell(
      onTap: () {
        // Navigate to user profile
      },
      child: Column(
        children: [
          Container(
            // height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(600),
                color: rank == 1 ? Colors.yellow : Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: bigger ? 40 : 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl) : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreList(List<Map<String, dynamic>> remainingUsers) {
    return ListView.builder(
      itemCount: remainingUsers.length,
      itemBuilder: (context, index) {
        var user = remainingUsers[index];
        return Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white, // Soft grey background for each item
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: user['photoUrl'] != null
                  ? NetworkImage(user['photoUrl'])
                  : null,
              backgroundColor: Colors.blueGrey,
              child: user['photoUrl'] == null
                  ? Text(
                user['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
                  : null,
            ),
            onTap: () {
              // Navigate to user's profile
            },
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textColor: Colors.black,
            title: Text(user['name'] ?? "Unknown User"),
            subtitle: Text("Level: ${user['level'] ?? 0}"),
            trailing: Text("#${index + 4}"),
          ),
        );
      },
    );
  }
}

// StarField Background widget
class StarFieldBackground extends StatelessWidget {
  const StarFieldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(100, (index) {
        return Positioned(
          top: Random().nextDouble() * MediaQuery.of(context).size.height,
          left: Random().nextDouble() * MediaQuery.of(context).size.width,
          child: Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
