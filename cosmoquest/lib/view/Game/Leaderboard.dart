import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/view/Auth/Profile.dart';
import 'package:flutter/material.dart';


class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                    _buildTopUser(context, "2nd", Colors.grey, 'assets/Icons/twitter.png'),
                    _buildTopUser(context, "1st", Colors.amber, "assets/Icons/google.png", bigger: true),
                    _buildTopUser(context, "3rd", Colors.brown, "assets/Icons/facebook.png"),
                  ],
                ),
              ),
              // Tab views for other scores
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScoreList(),
                    _buildScoreList(),
                    _buildScoreList(),
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
Widget _buildTopUser(BuildContext context, String rank, Color color, String imagePath, {bool bigger = false}) {
  return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()));
      },
      child: Column(
      children: [
        CircleAvatar(
          radius: bigger ? 50 : 40,
          backgroundColor: color,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          rank,
          style: TextStyle(
            fontSize: bigger ? 24 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
        ),
    );
}

// Placeholder for scores list
Widget _buildScoreList() {
  return ListView.builder(
    itemCount: 10, // Replace with dynamic data later
    itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Text(
            "#${index + 4}", // Adjust for ranking after top 3
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text("User ${index + 4}"),
        trailing: Text("Score: ${(100 - index) * 10}"),
      );
    },
  );
}

