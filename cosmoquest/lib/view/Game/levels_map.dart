import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:cosmoquest/view/Game_2/Screens/ExoplanetBuilderScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/MatchingGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/PuzzleChallengeScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/SpaceAdventureGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/TriviaQuizScreen.dart';
import 'package:cosmoquest/view/Game_2/document_screen.dart';
import 'package:cosmoquest/view/Game_2/learning_screen.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:flutter/material.dart';

import '../Game_2/Screens/MemoryGameScreen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  _LevelMapScreenState createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  List<bool> levelLocks = List.generate(20, (index) => true); // All levels start locked

  // Function to handle tap on a level
  void _onLevelTap(int index) {
    if (!levelLocks[index]) {
      List<LevelModel> levels = getLevelsData();
      LevelModel currentLevel = levels[index]; // Get the level data

      // Navigate to the learning part (video or document)
      if (currentLevel.learningType == "video") {
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => VideoPlayerScreen(currentLevel.learningContent),
            builder: (context) => LearningScreen(learningContent: currentLevel.learningContent, level: currentLevel),
          ),
        );
      } else if (currentLevel.learningType == "document") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LearningScreen(learningContent: currentLevel.learningContent, level: currentLevel),
          ),
        );
      }

      // After learning, navigate to the games based on the current level's games
      // for (String game in currentLevel.games) {
      //   switch (game) {
      //     case "Trivia Quiz":
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => TriviaQuizScreen()),
      //       );
      //       break;
      //     case "Matching Game":
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => MatchingGameScreen()),
      //       );
      //       break;
      //     case "Puzzle Challenge":
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => PuzzleChallengeScreen()),
      //       );
      //       break;
      //     case "Memory Game":
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => MemoryGameScreen()),
      //       );
      //       break;
      //     case "Exoplanet Builder":
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => ExoplanetBuilderScreen()),
      //       );
      //       break;
      //     case "Space Adventure Game":
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => SpaceAdventureGameScreen()),
      //       );
      //       break;
      //     default:
      //       print("Unknown game: $game");
      //   }
      // }
    } else {
      setState(() {
        levelLocks[index] = false; // Unlock level
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: AppBar(
    //   title: const Text('Game Levels'),
    // ),
    //   bottomNavigationBar: BottomAppBar(
    //     color: const Color(0xff3C2D4E), // A deep space-like purple
    //     shape: const CircularNotchedRectangle(), // Adds a floating effect to the buttons
    //     notchMargin: 8.0,
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 10.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           IconButton(
    //             icon: Icon(Icons.filter_1_rounded, color: Colors.white),
    //             onPressed: () {
    //               // Navigate to Levels screen
    //             },
    //             tooltip: 'Levels',
    //             iconSize: 28,
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.leaderboard, color: Colors.white),
    //             onPressed: () {
    //               // Navigate to Leaderboard screen
    //             },
    //             tooltip: 'Leaderboard',
    //             iconSize: 28,
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.person_outline, color: Colors.white),
    //             onPressed: () {
    //               // Navigate to Profile screen
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()));
    //             },
    //             tooltip: 'Profile',
    //             iconSize: 28,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),

      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Background/BG Level.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3), // Dark overlay for better text contrast
            ),
          ),
          InteractiveViewer(
            panEnabled: true, // Enable panning
            boundaryMargin: const EdgeInsets.all(100), // Adds some margins for panning
            minScale: 1.0, // Minimum zoom scale
            maxScale: 2.0, // Maximum zoom scale
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Background/Game Level.png'),
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Level buttons positioned manually based on image coordinates
                Positioned(
                  left: 47,
                  top: 491,
                  child: _buildLevelButton(0), // Level 1
                ),
                Positioned(
                  left: 100,
                  top: 480,
                  child: _buildLevelButton(1), // Level 2
                ),
                Positioned(
                  left: 152,
                  top: 470,
                  child: _buildLevelButton(2), // Level 3
                ),
                Positioned(
                  left: 201,
                  top: 460,
                  child: _buildLevelButton(3), // Level 4
                ),
                Positioned(
                  left: 255,
                  top: 450,
                  child: _buildLevelButton(4), // Level 5
                ),
                // Continue positioning buttons for other levels similarly...
                Positioned(
                  left: 310,
                  top: 430,
                  child: _buildLevelButton(5), // Level 6
                ),
                Positioned(
                  left: 370,
                  top: 220,
                  child: _buildLevelButton(6), // Level 7
                ),
                Positioned(
                  left: 420,
                  top: 180,
                  child: _buildLevelButton(7), // Level 8
                ),
                Positioned(
                  left: 470,
                  top: 140,
                  child: _buildLevelButton(8), // Level 9
                ),
                Positioned(
                  left: 520,
                  top: 100,
                  child: _buildLevelButton(9), // Level 10
                ),
              ],
            ),
          ),
        ],

      ),
    );
  }

  // Widget to build level buttons
  Widget _buildLevelButton(int index) {
    return GestureDetector(
      onTap: () => _onLevelTap(index),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.white30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(levelLocks[index] ? Icons.lock : null, color: Colors.white, size: 15,),
            // Positioned(
            //   bottom: -10,
            //   child: Text(
            //     '${index + 1}',
            //     style: const TextStyle(fontSize: 24, color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
