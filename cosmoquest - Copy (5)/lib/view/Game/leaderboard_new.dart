import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTopSectionVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll(double offset) {
    setState(() {
      _isTopSectionVisible = offset <= 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme background
      appBar: AppBar(
        title: Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab(),
          _buildLeaderboardTab(),
          _buildLeaderboardTab(),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        _onScroll(scrollInfo.metrics.pixels);
        return true;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                _isTopSectionVisible ? _buildTopThreeUsers() : Container(),
                Expanded(child: _buildRankList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeUsers() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildUserCircle('Jackson', 1847, 'assets/avatar1.png'),
          Stack(
            children: [
              _buildUserCircle('Edan', 2430, 'assets/avatar2.png'),
              Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.crop_3_2, color: Colors.yellow, size: 30),
              ),
            ],
          ),
          _buildUserCircle('Emma Aria', 1674, 'assets/avatar3.png'),
        ],
      ),
    );
  }

  Widget _buildUserCircle(String name, int score, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(imageUrl),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          score.toString(),
          style: TextStyle(color: Colors.greenAccent, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRankList() {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar${(index % 3) + 1}.png'),
          ),
          title: Text(
            'User $index',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            '${1000 - index * 10}',
            style: TextStyle(color: Colors.greenAccent),
          ),
        );
      },
    );
  }
}
