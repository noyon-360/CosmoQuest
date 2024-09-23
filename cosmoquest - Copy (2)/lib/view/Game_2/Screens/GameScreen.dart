import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/loading_animation.dart';
import 'package:cosmoquest/view/Game_2/Screens/ExoplanetBuilderScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/MatchingGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/MemoryGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/PuzzleChallengeScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/SpaceAdventureGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/TriviaQuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:cosmoquest/Utils/Game_2/game_contants.dart';
import 'package:lottie/lottie.dart';

class GamesScreen extends StatelessWidget {
  final LevelModel level;

  const GamesScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: Lottie.asset(
              'assets/Animations/loading space.json', // Replace with your animation
              repeat: false, // Ensure the animation plays only once
            ),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: level.games.map((game) {
                switch (game) {
                  case GameTypes.triviaQuiz:
                    return ListTile(
                      title: Center(child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(6), // Rounded corners

                        ),
                        child: Column(
                          children: [
                            Text("Start",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Text("Trivia Quiz"),
                          ],
                        ),
                      )),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TriviaQuizScreen(level: level),
                          ),
                        );
                      },
                    );
                  case GameTypes.matchingGame:
                    return ListTile(
                      title: const Center(child: Column(
                        children: [
                          Text("Start",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("Matching Game"),
                        ],
                      )),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatchingGameScreen(),
                          ),
                        );
                      },
                    );
                  case GameTypes.puzzleChallenge:
                    return ListTile(
                      title: const Center(child: Column(
                        children: [
                          Text("Start",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("Puzzle Challenge"),
                        ],
                      )),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PuzzleChallengeScreen(),
                          ),
                        );
                      },
                    );
                  case GameTypes.memoryGame:
                    return ListTile(
                      title: const Center(child: Column(
                        children: [
                          Text("Start",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("Memory Game"),
                        ],
                      )),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemoryGameScreen(),
                          ),
                        );
                      },
                    );
                  case GameTypes.exoplanetBuilder:
                    return ListTile(
                      title: const Center(child: Column(
                        children: [
                          Text("Start",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("Exoplanet Builder"),
                        ],
                      )),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExoplanetBuilderScreen(),
                          ),
                        );
                      },
                    );
                  case GameTypes.spaceAdventureGame:
                    return ListTile(
                      title: const Center(child: Column(
                        children: [
                          Text("Start",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("Space Adventure Game"),
                        ],
                      )),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpaceAdventureGameScreen(),
                          ),
                        );
                      },
                    );
                  default:
                    return Container();
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
