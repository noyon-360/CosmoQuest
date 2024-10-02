// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cosmoquest/Model/user_progress.dart';
// import 'package:flutter/material.dart';
//
// class LeaderboardPage extends StatefulWidget {
//   const LeaderboardPage({super.key});
//
//   @override
//   State<LeaderboardPage> createState() => _LeaderboardPageState();
// }
//
// class _LeaderboardPageState extends State<LeaderboardPage>
//     with SingleTickerProviderStateMixin {
//   List<Map<String, dynamic>> usersData = [];
//   TabController? _tabController;
//   UserProgressFireStore userProgressFireStore = UserProgressFireStore();
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _fetchUsersData(); // Initial data fetch
//     _tabController?.addListener(_onTabChange); // Add listener for tab changes
//   }
//
//   // Listen for changes in the users collection and update usersData
//   void _onTabChange() {
//     if (_tabController!.indexIsChanging) {
//       _fetchUsersData();
//     }
//   }
//
//   Future<void> _fetchUsersData() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
//       List<Map<String, dynamic>> fetchData = [];
//
//       for (var doc in snapshot.docs) {
//         String uid = doc.id;
//         String displayName = doc['displayName'];
//         String photoUrl = doc['photoURL'];
//
//         try {
//           DocumentSnapshot progressSnapshot = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(uid)
//               .collection('user_progress')
//               .doc('details')
//               .get();
//
//           if (progressSnapshot.exists) {
//             var level = progressSnapshot['level'];
//             var allTimeRatings = await userProgressFireStore.getAverageRatings('all_time');
//             var todayRatings = await userProgressFireStore.getAverageRatings('today');
//             var weeklyRatings = await userProgressFireStore.getAverageRatings('weekly');
//
//             fetchData.add({
//               'uid': uid,
//               'name': displayName,
//               'photoUrl': photoUrl,
//               'level': level,
//               'allTimeRating': allTimeRatings[level]['averageRating'],
//               'todayRating': todayRatings[level]['averageRating'],
//               'weeklyRating': weeklyRatings[level]['averageRating'],
//             });
//           } else {
//             fetchData.add({
//               'uid': uid,
//               'name': displayName,
//               'photoUrl': photoUrl,
//               'level': 0,
//               'allTimeRating': 0,
//               'todayRating': 0,
//               'weeklyRating': 0,
//             });
//           }
//         } catch (e) {
//           fetchData.add({
//             'uid': uid,
//             'name': displayName,
//             'photoUrl': photoUrl,
//             'level': 0,
//             'allTimeRating': 0,
//             'todayRating': 0,
//             'weeklyRating': 0,
//           });
//         }
//       }
//
//       fetchData.sort((a, b) => b['level']?.compareTo(a['level']) ?? 0);
//       setState(() {
//         usersData = fetchData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(color: Colors.white70),
//           NestedScrollView(
//             headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                   pinned: false,
//                   expandedHeight: MediaQuery.of(context).size.height * 0.5,
//                   backgroundColor: Color(0xff08142e),
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height * 0.5,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(30),
//                               bottomRight: Radius.circular(30),
//                             ),
//                             image: DecorationImage(
//                               image: AssetImage('assets/Background/Leaderboard back 2.jpg'),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 40.0,
//                                   left: 20.0,
//                                   right: 20.0,
//                                   bottom: 10.0,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Leaderboard", style: TextStyle(fontSize: 24)),
//                                     Icon(Icons.share),
//                                   ],
//                                 ),
//                               ),
//                               TabBar(
//                                 controller: _tabController,
//                                 tabs: const [
//                                   Tab(text: "All Time"),
//                                   Tab(text: "Today"),
//                                   Tab(text: "Weekly"),
//                                 ],
//                                 dividerColor: Colors.transparent,
//                                 labelColor: Colors.white,
//                                 unselectedLabelColor: Colors.white70,
//                                 indicatorColor: Colors.yellow,
//                                 indicatorWeight: 2.0,
//                                 indicatorSize: TabBarIndicatorSize.label,
//                               ),
//                               Spacer(),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   _buildUserPodium(2),
//                                   _buildUserPodium(1, isFirst: true),
//                                   _buildUserPodium(3),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ];
//             },
//             body: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildScoreList(usersData.skip(3).toList()), // All Time
//                 _buildScoreList(usersData.skip(3).toList()), // Today
//                 _buildScoreList(usersData.skip(3).toList()), // Weekly
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUserPodium(int rank, {bool isFirst = false}) {
//     return Column(
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.bottomCenter,
//           children: [
//             Container(
//               width: 100,
//               height: isFirst ? 150 : 100,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(isFirst ? 30 : 20),
//                   topRight: Radius.circular(isFirst ? 30 : 20),
//                 ),
//                 color: isFirst ? Color(0xFF252A40) : Color(0xFF202236),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   if (usersData.length > rank - 1)
//                     Text(usersData[rank - 1]['name'] ?? 'Unknown'),
//                   if (usersData.length > rank - 1)
//                     Text(usersData[rank - 1]['level'].toString()),
//                   if (usersData.length > rank - 1)
//                     Text("All Time Rating: ${usersData[rank - 1]['allTimeRating']?.toStringAsFixed(2) ?? '0.0'}")
//                 ],
//               ),
//             ),
//             if (usersData.length > rank - 1)
//               Positioned(
//                 top: isFirst ? -80 : -30,
//                 child: Column(
//                   children: [
//                     if (isFirst)
//                       Image.asset("assets/Icons/crown.png", width: 60),
//                     _buildTopUser(
//                       context,
//                       rank,
//                       Colors.grey,
//                       usersData[rank - 1]['photoUrl'] as String?,
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTopUser(BuildContext context, int rank, Color color, String? imageUrl, {bool bigger = false}) {
//     return InkWell(
//       onTap: () {
//         // Navigate to user profile
//       },
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(600),
//               color: rank == 1 ? Colors.yellow : Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: bigger ? 40 : 30,
//                     backgroundColor: Colors.transparent,
//                     backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScoreList(List<Map<String, dynamic>> remainingUsers) {
//     return ListView.builder(
//       itemCount: remainingUsers.length,
//       itemBuilder: (context, index) {
//         var user = remainingUsers[index];
//         return Container(
//           margin: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: Color(0xFF202236),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(user['photoUrl']),
//             ),
//             title: Text(user['name']),
//             subtitle: Text("Level: ${user['level']} | All Time Rating: ${user['allTimeRating']?.toStringAsFixed(2)}"),
//           ),
//         );
//       },
//     );
//   }
// }
