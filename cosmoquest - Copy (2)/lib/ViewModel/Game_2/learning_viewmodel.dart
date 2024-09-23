import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:flutter/material.dart';

class LearningViewModel with ChangeNotifier {
  LevelModel? currentLevel;
  int currentLevelNumber = 1; // Default to level 1

  void loadLevel(int levelNumber) {
    List<LevelModel> levels = getLevelsData();
    currentLevel = levels.firstWhere((level) => level.levelNumber == levelNumber);
    currentLevelNumber = levelNumber;
    notifyListeners();
  }

  bool isVideoLearning() {
    return currentLevel?.learningType == "video";
  }
 
  bool isDocumentLearning() {
    return currentLevel?.learningType == "document";
  }

  List<String> getLevelGames() {
    return currentLevel?.games ?? [];
  }
}
