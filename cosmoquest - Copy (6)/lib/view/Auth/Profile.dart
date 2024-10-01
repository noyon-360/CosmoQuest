import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Model/UserModel.dart';
import 'package:cosmoquest/Service/user_service.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/ViewModel/Leaderborad/leaderboard_view_model.dart';
import 'package:cosmoquest/ViewModel/UserProfileViewModel.dart';
import 'package:cosmoquest/view/Auth/profile_edit_manu.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late UserProfileViewModel _userProfileViewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _userProfileViewModel = UserProfileViewModel();

    // Fetch user data and position in leaderboard
    _fetchUserDataAndPosition();
  }

  Future<void> _fetchUserDataAndPosition() async {
    await _userProfileViewModel.fetchUserData(Apis.user.uid.toString());
    await _userProfileViewModel
        .fetchUserPositionInLeaderboard(Apis.user.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProfileViewModel>.value(
      value: _userProfileViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xff0d1a26),
        // Darker professional background
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow for a clean look
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditPage(uid: Apis.user.uid)));
            }, icon: Icon(Icons.edit)),
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            _userProfileViewModel.logout(context);
                          },
                          child: const Text("Logout", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );

              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Consumer<UserProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            UserModel? user = viewModel.userModel;
            if (user == null) {
              return const Center(
                child: Text(
                  "No user data found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amber,
                        boxShadow: [BoxShadow(color: Colors.black12)]),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CachedNetworkImage(
                        color: Colors.amber,
                        imageUrl: user.photoURL!,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                            child: const CircularProgressIndicator(
                          color: Colors.blueGrey,
                        )),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display Name
                  Text(
                    user.displayName ?? "Unknown User",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Email
                  Text(
                    user.email ?? "No email provided",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 20),
                  // Tabs for Achievements and Activity
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.amber,
                      unselectedLabelColor: Colors.grey.shade400,
                      indicatorColor: Colors.amber,
                      tabs: const [
                        Tab(text: "ACHIEVEMENTS"),
                        Tab(text: "ACTIVITY"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tab Content
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.5, // Dynamically allocate height
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        achievementsTab(viewModel),
                        activityTab(viewModel),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget achievementsTab(UserProfileViewModel viewModel) {
    int totalScore = 20 * 10; // 20 levels, each with a max of 10 points
    int userAchievedPoints =
        viewModel.userRatings.fold(0, (sum, rating) => sum + rating);
    double progressValue = userAchievedPoints / totalScore;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level Progress Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level ${(int.parse(viewModel.userLevel.toString()) + 1).toString()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(20),
                  value: progressValue,
                  backgroundColor: Colors.grey.shade700,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  minHeight: 8,
                ),
                const SizedBox(height: 10),
                Text(
                  "$userAchievedPoints / $totalScore Score",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Stats Section
          Text(
            'Stats',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: statCard(Icons.flash_on_outlined, "55", "Quizzes"),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: statCard(Icons.leaderboard,
                    "#${viewModel.currentPosition}", "Leaderboard"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statCard(IconData icon, String statValue, String label) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.amber),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statValue,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget activityTab(UserProfileViewModel viewModel) {
    List<LevelModel> levelsData = getLevelsData();

    return ListView.builder(
      itemCount: levelsData.length,
      itemBuilder: (context, index) {
        // Access the level model
        LevelModel level = levelsData[index];

        // Find the rating for this level using the level number
        int? levelRating;
        if (viewModel.userRatings.length > level.levelNumber - 1) {
          levelRating = viewModel.userRatings[level.levelNumber -
              1]; // Assuming userRatings is indexed by level number
        }
        // Calculate percentage (out of 10)
        double percentage = levelRating != null ? (levelRating / 10) * 100 : 0;

        return ListTile(
          trailing: levelRating != null && percentage > 10
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 40, // Circular progress indicator size
                      height: 40,
                      child: CircularProgressIndicator(
                        value: percentage / 100,
                        // Progress based on the percentage (scaled to 0-1)
                        strokeWidth: 4,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.amber, // Customize the progress color
                      ),
                    ),
                    Text(
                      "${percentage.toStringAsFixed(0)}%", // Show the percentage
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  "N/A", // Display N/A if no rating is available or percentage < 10%
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
          leading: CircleAvatar(
            radius: 25, // Adjust the size of the circle
            backgroundColor: Colors.white60, // Set background color
            child: Text(
              level.levelNumber.toString(), // Display the level number inside the circle
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color for better contrast
              ),
            ),
          ),
          title: Text(
            level.title, // Display the title of each level
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(level.subtitle),
          // Display the subtitle of each level
          onTap: () {
            // Define any action when the list item is tapped
          },
        );
      },
    );
  }
}
