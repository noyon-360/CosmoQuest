import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Utils/date_checker.dart';
import 'package:cosmoquest/ViewModel/Leaderborad/leaderboard_view_model.dart';
import 'package:cosmoquest/view/Leaderboard/leaderboard_share_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  // List<Map<String, dynamic>> usersData = [];
  TabController? _tabController;
  UserProgressFireStore userProgressFireStore = UserProgressFireStore();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      final leaderboardViewModel =
      Provider.of<LeaderboardViewModel>(context, listen: false);
      leaderboardViewModel.fetchLeaderboardData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffcbd3e4),
        body: Consumer<LeaderboardViewModel>(builder: (context, viewModel, child){
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.hasError) {
            return Center(
              child: Text(viewModel.errorMessage),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Color(0xff01103b),
                elevation: 10,
                pinned: true,
                centerTitle: false,
                stretch: true,
                title: Text("Leaderboard"),
                actions: [
                  IconButton(
                    onPressed: () {
                      // Assuming you want to share the first user for example
                      if (viewModel.leaderboardData['allTime']!.isNotEmpty) {
                        final selectedUser = viewModel.leaderboardData['allTime']![
                        0]; // Get the top user from the all-time list
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeaderboardSharePage(
                                userData: selectedUser),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.share),
                  ),
                ],
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [StretchMode.zoomBackground],
                    background: Container(
                      decoration: BoxDecoration(
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: TabBar(
                              controller: _tabController,
                              tabs: const [
                                Tab(text: "All Time"),
                                Tab(text: "Today"),
                                Tab(text: "Weekly"),
                              ],
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white70,
                              indicatorColor: Colors.yellow,
                              indicatorWeight: 2.0,
                              indicatorSize: TabBarIndicatorSize.label,
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    _buildUserPodium(
                                        viewModel.leaderboardData['allTime']!, 2),
                                    _buildUserPodium(
                                        viewModel.leaderboardData['allTime']!, 1,
                                        isFirst: true),
                                    _buildUserPodium(
                                        viewModel.leaderboardData['allTime']!, 3),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    _buildUserPodium(
                                        viewModel.leaderboardData['today']!, 2),
                                    _buildUserPodium(
                                        viewModel.leaderboardData['today']!, 1,
                                        isFirst: true),
                                    _buildUserPodium(
                                        viewModel.leaderboardData['today']!, 3),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    _buildUserPodium(
                                        viewModel.leaderboardData['weekly']!, 2),
                                    _buildUserPodium(
                                        viewModel.leaderboardData['weekly']!, 1,
                                        isFirst: true),
                                    _buildUserPodium(
                                        viewModel.leaderboardData['weekly']!, 3),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildScoreList(
                          viewModel.leaderboardData['allTime']!), // All Time
                      _buildScoreList(viewModel.leaderboardData['today']!), // Today
                      _buildScoreList(viewModel.leaderboardData['weekly']!), // Weekly
                    ],
                  ),
                ),
              ),
            ],
          );
        })

    );
  }

  Widget _buildUserPodium(List<Map<String, dynamic>> leaderboardList, int rank,
      {bool isFirst = false}) {
    // Check if leaderboardList contains enough users for this rank
    if (leaderboardList.length < rank) {
      return SizedBox.shrink(); // Return an empty widget if not enough users
    }

    final user = leaderboardList[rank - 1]; // Get the user at this rank

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 115,
          height: isFirst ? 160 : 135, // Make the first place podium taller
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isFirst ? 30 : 20),
              topRight: Radius.circular(isFirst ? 30 : 20),
            ),
            color: isFirst ? Color(0xFF252A40) : Color(0xFF202236),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(user['user']['name'] ?? 'Unknown', textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Level: ${user['level']}",
                    style: TextStyle(color: Colors.white70)),
                Text(
                  "Score: ${user['score']}",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: isFirst ? -80 : -30,
          child: Column(
            children: [
              if (isFirst) Image.asset("assets/Icons/crown.png", width: 60),
              // Crown for first place
              _buildTopUser(
                context,
                rank,
                Colors.grey,
                user['user']['photoUrl'] as String?,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopUser(
      BuildContext context, int rank, Color borderColor, String? imageUrl,
      {bool bigger = false}) {
    return InkWell(
      onTap: () {
        // You can handle navigation to the user's profile or other actions here.
      },
      child: Column(
        children: [
          // Outer circle with rank-specific color
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              // More reasonable circular border
              color: rank == 1
                  ? Colors.yellow
                  : Colors.white, // First rank gets yellow
            ),
            padding: const EdgeInsets.all(3.0), // Padding around the avatar
            child: CircleAvatar(
              radius: bigger ? 40 : 30, // Bigger avatar if `bigger` is true
              backgroundColor: borderColor, // Border color around the avatar
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Icon(Icons.person,
                      color: Colors.grey,
                      size: bigger ? 40 : 30) // Placeholder if no image
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreList(List<Map<String, dynamic>> leaderboardList) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: leaderboardList.length,
        itemBuilder: (BuildContext context, int index) {
          final data = leaderboardList[index];
          final user = data['user'];
          final score = data['score'];

          String scoreDisplay =
              score > 0 ? 'Score: $score' : 'Score: #'; // Use # for zero scores

          return Card(
            color: Color(0xe5191930),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // Set rounded corners
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            // Add gap between list items
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
              ),
              title: Text(user['name'] ?? 'Unknown'),
              subtitle: Text('Level: ${data['level'] ?? 'N/A'}'),
              trailing: Text(scoreDisplay),
            ),
          );
        },
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            // borderRadius: ,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 12.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                hintText: 'Restaurants or dish...',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
