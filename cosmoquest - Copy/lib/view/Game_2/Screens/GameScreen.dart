import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/view/Game_2/Screens/ExoplanetBuilderScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/MatchingGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/MemoryGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/PuzzleChallengeScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/SpaceAdventureGameScreen.dart';
import 'package:cosmoquest/view/Game_2/Screens/TriviaQuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:cosmoquest/Utils/Game_2/game_contants.dart';

class GamesScreen extends StatelessWidget {
  final LevelModel level;

  const GamesScreen({super.key, required this.level});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Games Screen")),
      body: ListView(
        children: level.games.map((game) {
          switch (game) {
            case GameTypes.triviaQuiz:
              return ListTile(
                title: const Text("Trivia Quiz"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TriviaQuizScreen(level: level),
                    ),
                  );
                },
              );
            case GameTypes.matchingGame:
              return ListTile(
                title: const Text("Matching Game"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchingGameScreen(),
                    ),
                  );
                },
              );
            case GameTypes.puzzleChallenge:
              return ListTile(
                title: const Text("Puzzle Challenge"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PuzzleChallengeScreen(),
                    ),
                  );
                },
              );
            case GameTypes.memoryGame:
              return ListTile(
                title: const Text("Memory Game"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MemoryGameScreen(),
                    ),
                  );
                },
              );
            case GameTypes.exoplanetBuilder:
              return ListTile(
                title: const Text("Exoplanet Builder"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExoplanetBuilderScreen(),
                    ),
                  );
                },
              );
            case GameTypes.spaceAdventureGame:
              return ListTile(
                title: const Text("Space Adventure Game"),
                onTap: () {
                  Navigator.push(
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
    );
  }
}
