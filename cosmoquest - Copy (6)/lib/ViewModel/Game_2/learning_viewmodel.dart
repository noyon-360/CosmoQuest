import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:flutter/material.dart';

class LearningViewModel with ChangeNotifier {
  LevelModel? currentLevel;
  int currentLevelNumber = 1; // Default to level 1
  int currentLearningIndex = 0; // To track which part (video/document) is being displayed

  void loadLevel(int levelNumber) {
    List<LevelModel> levels = getLevelsData();
    currentLevel = levels.firstWhere((level) => level.levelNumber == levelNumber);
    currentLevelNumber = levelNumber;
    currentLearningIndex = 0; // Reset the learning index when a new level is loaded
    notifyListeners();
  }

  List<LearningPart> getLearningParts() {
    return currentLevel?.learningParts ?? [];
  }

  // To check if the current learning part is a video
  bool isCurrentLearningVideo() {
    if (currentLevel != null && currentLearningIndex < currentLevel!.learningParts.length) {
      return currentLevel!.learningParts[currentLearningIndex].type == "video";
    }
    return false;
  }

  // To check if the current learning part is a document
  bool isCurrentLearningDocument() {
    if (currentLevel != null && currentLearningIndex < currentLevel!.learningParts.length) {
      return currentLevel!.learningParts[currentLearningIndex].type == "document";
    }
    return false;
  }

  // To get the content of the current learning part (video/document URL or path)
  String getCurrentLearningContent() {
    if (currentLevel != null && currentLearningIndex < currentLevel!.learningParts.length) {
      return currentLevel!.learningParts[currentLearningIndex].content;
    }
    return '';
  }

  // To navigate to the next learning part
  void goToNextLearningPart() {
    if (currentLevel != null && currentLearningIndex < currentLevel!.learningParts.length - 1) {
      currentLearningIndex++;
      notifyListeners();
    }
  }

  // To check if there are more learning parts available
  bool hasMoreLearningParts() {
    return currentLevel != null && currentLearningIndex < currentLevel!.learningParts.length - 1;
  }

  List<String> getLevelGames() {
    return currentLevel?.games ?? [];
  }
}
