import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/view/Auth/Profile.dart';
import 'package:cosmoquest/view/Map%20Containers/container_list.dart';
import 'package:cosmoquest/view/UsersDetails/users_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
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
        usersData = fetchData; // Update the state with fetched data
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness:
          Brightness.light, // Light icons on the status bar
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Leaderboard"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
        backgroundColor: Colors.transparent,
        // Makes AppBar transparent
        elevation: 0,
        // Removes AppBar shadow
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          tabs: const [
            Tab(text: "Galactic Day"),
            Tab(text: "Star Week"),
            Tab(text: "Cosmic Month"),
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
      ),
      body: Stack(
        children: [
          // Cosmic background with animated stars
          Container(
            color: Colors.white.withOpacity(0.9),
          ),
          // const StarFieldBackground(),
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image:
                        AssetImage('assets/Background/Leaderboard back 2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 2nd
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      height: 150,
                                      // color: Colors.yellow,
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only( topLeft: Radius.circular(20)),
                                            color: Color(0xFFBBBBBB)
                                          ),
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("data")
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    if (usersData.length > 1)
                                      Positioned(
                                        top: 12,
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
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      height: 230,
                                      // color: Colors.yellow,
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 150,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                              color: Color(0xFFFEDE00)
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (usersData.length > 1)
                                      Positioned(
                                        top: 0,
                                        child: Column(
                                          children: [
                                            Image.asset("assets/Icons/crown.png", width: 60,),
                                            _buildTopUser(
                                              context,
                                              2,
                                              Colors.grey,
                                              usersData[0]['photoUrl'] as String?,
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
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      height: 150,
                                      // color: Colors.yellow,
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only( topRight: Radius.circular(20)),
                                              color: Color(0xFFC27E3E)
                                          ),
                                        ),

                                      ],
                                    ),
                                    if (usersData.length > 1)
                                      Positioned(
                                        top: 12,
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
                    _buildScoreList(usersData.skip(3).toList()), // Cosmic Month
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

  Widget _buildTopUserRankings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.stretch ,
      children: [
        if (usersData.length > 1)
          Column(
            // alignment: Alignment.center,
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Image.asset(getRankImage(2), width: 60),
              _buildTopUser(
                context,
                2,
                Colors.grey,
                usersData[1]['photoUrl'] as String?,
                // usersData[1]['name'] as String?,
                // usersData[1]['level']?.toString()
              ),
              // Image.asset(
              //   'assets/Background/Stage 2.png',
              //   width: 60,
              // )
            ],
          ),
        if (usersData.isNotEmpty)
          Column(
            // alignment: Alignment.center,
            children: [
              Image.asset(getRankImage(1), width: 80),
              _buildTopUser(
                  context, 1, Colors.amber, usersData[0]['photoUrl'] as String?,
                  // usersData[0]['name'] as String?,
                  // usersData[0]['level']?.toString(),
                  bigger: true),
              // Image.asset(
              //   'assets/Background/Stage 1.png',
              //   width: 90,
              // )
            ],
          ),
        if (usersData.length > 2)
          Column(
            // alignment: Alignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(getRankImage(3), width: 80),
              _buildTopUser(
                context,
                3,
                Colors.brown,
                usersData[2]['photoUrl'] as String?,
                // usersData[2]['name'] as String?,
                // usersData[2]['level']?.toString()
              ),

              // Image.asset('assets/Background/Stage 3.png', width: 60, fit:BoxFit.cover,)
            ],
          )
      ],
    );
  }
}

// Widget for top users
Widget _buildTopUser(
    BuildContext context, int rank, Color color, String? imageUrl,
    {bool bigger = false}) {
  // String getRankImage(int rank) {
  //   switch (rank) {
  //     case 1:
  //       return 'assets/Icons/crown.png';
  //     case 2:
  //       return 'assets/Icons/Badges-space.png';
  //     case 3:
  //       return 'assets/Icons/Badges-reach-moon.png';
  //     default:
  //       return 'assets/Icons/Badges-moon.png';
  //   }
  // }

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
        // const SizedBox(height: 8),
        // Text(
        //   displayName ?? "Astronaut",
        //   style: TextStyle(
        //     fontSize: bigger ? 12 : 10,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
        // Text("Level: ${level ?? 0}",
        //     style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    ),
  );
}

// Score list beyond top 3 users
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
            backgroundImage:
                user['photoUrl'] != null ? NetworkImage(user['photoUrl']) : null,
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
