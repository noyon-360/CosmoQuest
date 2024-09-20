import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:cosmoquest/Utils/SnackbarUtil.dart';
import 'package:cosmoquest/view/ExoplanetDiscover/exoplanet_discover.dart';
import 'package:cosmoquest/view/Game_2/learning_screen.dart';
import 'package:flutter/material.dart';


class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  _LevelMapScreenState createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  List<bool> levelLocks = List.generate(20, (index) => true); // All levels start locked
  List<int> ratings = List.generate(20, (index) => 0);

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final userProgress = UserProgressLocalStore();
    int currentLevel = await userProgress.getLevel() ?? 0;
    List<int> savedRating = await userProgress.getRating();

    setState(() {
      levelLocks = List.generate(20, (index) => index > currentLevel);
      ratings = savedRating;
    });
  }

  Future<void> _resetLevels() async {
    final userProgressLocalStore = UserProgressLocalStore();
    final userProgressFireStore = UserProgressFireStore();

    await userProgressLocalStore.resetProgress(); // Implement this method in UserProgress to reset user data
    await userProgressFireStore.resetProgress();

    setState(() {
      // Unlock only the first level, lock all other levels
      levelLocks = List.generate(20, (index) => index != 0); // Unlock the first level (index 0) only
    });

    SnackBarUtil.showSnackbar(context, 'Levels have been reset. Only the first level is unlocked.');
  }

  // Function to handle tap on a level
  void _onLevelTap(int index) {
    if (!levelLocks[index]) {
      List<LevelModel> levels = getLevelsData();
      LevelModel currentLevel = levels[index]; // Get the level data

      // Navigate to the learning part (video or document)
      if (currentLevel.learningType == "video" || currentLevel.learningType == "document") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LearningScreen(learningContent: currentLevel.learningContent, level: currentLevel),
          ),
        );
      }
    } else {
      SnackBarUtil.showSnackbar(context, 'Level ${index + 1} is locked.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final positions = [
      const Offset(24, 424),
      const Offset(100, 480),
      const Offset(152, 470),
      const Offset(201, 460),
      const Offset(255, 450),
      const Offset(310, 430),
      const Offset(370, 220),
      const Offset(420, 180),
      const Offset(470, 140),
      const Offset(520, 100),
      // Add more positions if you have more levels
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetLevels,
            tooltip: 'Reset Levels',
          ),
          IconButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (_) => const CMEData()));
          }, icon: const Icon(Icons.adjust_rounded))
        ],
      ),
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
                    ),
                  ),
                ),
                // Level buttons positioned manually based on image coordinates
                for (int i = 0; i < positions.length; i++)
                  Positioned(
                    left: positions[i].dx,
                    top: positions[i].dy,
                    child: Column(
                      children: [
                        _buildRatingStars(i),
                        _buildLevelButton(i),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int index) {
    int levelRating = ratings[index]; // Get the rating for the specific level (index)

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (starIndex) {
          return Icon(
            Icons.star,
            color: starIndex < levelRating ? Colors.yellow : Colors.grey, // Show gold stars up to the rating level
            size: 20,
          );
        }),
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
            Icon(levelLocks[index] ? Icons.lock : null, color: Colors.white, size: 15),
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
