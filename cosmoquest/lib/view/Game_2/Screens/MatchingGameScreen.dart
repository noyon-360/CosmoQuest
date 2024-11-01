import 'dart:async';
import 'dart:math';
import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/ViewModel/GameQuiz/MatchingGameViewModel.dart';
import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Game/NextLevel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchingGameScreen extends StatefulWidget {
  final LevelModel level;

  const MatchingGameScreen({super.key, required this.level});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    generateNewOptions();
  }

  final List<String> planetNames = [
    'Mercury',
    'Venus',
    'Earth',
    'Mars',
    'Jupiter',
    'Saturn',
    'Uranus',
    'Neptune',
  ];

  final Map<String, String> planetImages = {
    'Mercury': 'assets/images/Planet-_Mercury.png',
    'Venus': 'assets/images/Planet-_Venus.png',
    'Earth': 'assets/images/Planet-_Earth.png',
    'Mars': 'assets/images/Planet-_Mars.png',
    'Jupiter': 'assets/images/Planet-_Jupiter.png',
    'Saturn': 'assets/images/Planet-_Saturn.png',
    'Uranus': 'assets/images/Planet-_Uranus.png',
    'Neptune': 'assets/images/Planet-_Neptune.png',
  };

  String? currentPlanet;
  List<String> currentOptions = [];
  Map<String, bool> results = {};
  Map<String, Color> optionColors = {}; // Track colors for temp options
  List<String> shownPlanets = [];

  void generateNewOptions() {
    if (shownPlanets.length < planetNames.length) {
      List<String> remainingPlanets =
          planetNames.where((p) => !shownPlanets.contains(p)).toList();
      currentPlanet =
          remainingPlanets[Random().nextInt(remainingPlanets.length)];
      shownPlanets.add(currentPlanet!);

      List<String> tempOptions = List.from(planetNames)..remove(currentPlanet!);
      tempOptions.shuffle();
      currentOptions = [currentPlanet!, ...tempOptions.take(3)].toList();
      currentOptions.shuffle();

      optionColors = {
        for (var option in currentOptions) option: Colors.grey[200]!,
      };
    } else {
      currentPlanet = null;
      showFinalResults();
    }
  }

  int _calculateRating(int correctAnswers) {
    // Simple example of rating calculation, modify as needed
    if (correctAnswers >= 6) return 3;
    if (correctAnswers >= 4) return 2;
    return 1;
  }

  Future<void> checkForNextLevel(
      BuildContext context, int levelId, int correctAnswers, int rating) async {
    bool passed = correctAnswers >= 6;
    final userProgressLocalStore = UserProgressLocalStore();
    final userProgressFireStore = UserProgressFireStore();

    int currentLevel = levelId - 1;
    print(currentLevel);
    if (passed) {
      await userProgressLocalStore.saveLevel(currentLevel + 1);
      await userProgressFireStore.saveLevel(currentLevel + 1);
    }

    await userProgressLocalStore.saveRating(currentLevel, rating);
    await userProgressFireStore.saveRatingAndScore(
        currentLevel, rating, correctAnswers);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NextLevelScreen(
          passed: passed,
          rating: rating,
          onNextLevel: () =>
              _navigateTo(context, const BottomNavigationBarHome()),
          onRetry: () => _navigateTo(context, const BottomNavigationBarHome()),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false, // Removes all previous routes
    );
  }

  void showFinalResults() {
    int correct = results.values.where((v) => v == true).length;

    checkForNextLevel(
        context, widget.level.levelNumber, correct, _calculateRating(correct));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Planets with Names'),
      ),
      body: Column(
        children: [
          // Planet Name Options Section
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: currentOptions.length,
              itemBuilder: (context, index) {
                String planet = currentOptions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: optionColors[planet],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            planet,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      setState(() {
                        if (data == currentPlanet && planet == currentPlanet) {
                          optionColors[planet] = Colors.green;
                          results[currentPlanet!] = true;
                        } else {
                          optionColors[planet] = Colors.red;
                          results[currentPlanet!] = false;
                        }
                        // Delay before showing new options
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            generateNewOptions();
                          });
                        });
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Draggable Planet Image Section
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                if (currentPlanet != null)
                  Align(
                    alignment: Alignment.center,
                    child: Draggable<String>(
                      data: currentPlanet,
                      feedback: Transform.scale(
                        scale: 1.2,
                        child: Image.asset(
                          planetImages[currentPlanet!]!,
                          width: 120,
                          height: 120,
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          planetImages[currentPlanet!]!,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      child: Image.asset(
                        planetImages[currentPlanet!]!,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
