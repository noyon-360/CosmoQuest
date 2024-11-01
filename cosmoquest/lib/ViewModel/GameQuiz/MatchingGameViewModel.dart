import 'dart:math';
import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:flutter/material.dart';

class MatchingGameViewModel extends ChangeNotifier {

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

  List<String> currentOptions = [];
  String? currentPlanet;
  Map<String, bool> results = {};
  List<String> shownPlanets = [];
  int correctMatches = 0;


  void startGame() {
    shownPlanets.clear();
    results.clear();
    correctMatches = 0;
    generateNewOptions();
    notifyListeners();
  }

  void generateNewOptions() {
    if (shownPlanets.length < planetNames.length) {
      List<String> remainingPlanets = planetNames.where((p) => !shownPlanets.contains(p)).toList();
      currentPlanet = remainingPlanets[Random().nextInt(remainingPlanets.length)];
      shownPlanets.add(currentPlanet!);

      List<String> tempOptions = List.from(planetNames)..remove(currentPlanet!);
      tempOptions.shuffle();
      currentOptions = [currentPlanet!, ...tempOptions.take(3)].toList();
      currentOptions.shuffle();
    } else {
      currentPlanet = null;
    }
    notifyListeners();
  }

  void submitAnswer(String planetName, bool isCorrect) {
    results[planetName] = isCorrect;
    if (isCorrect) {
      correctMatches++;
    }
    notifyListeners();
  }

  void resetGame() {
    shownPlanets.clear();
    results.clear();
    correctMatches = 0;
  }
}
