import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/game_contants.dart';

List<LevelModel> getLevelsData() {
  return [
    LevelModel(
      levelNumber: 1,
      learningType: "video",
      learningContent: "/game/level_1/We Bee - Personal - Microsoft​ Edge 2024-09-11 11-41-27.mp4", // Example URL for video
      games: [
        GameTypes.triviaQuiz,
        // GameTypes.puzzleChallenge,
      ],
    ),
    LevelModel(
      levelNumber: 2,
      // learningType: "document",
      learningType: "video",
      learningContent: "/game/level_1/We Bee - Personal - Microsoft​ Edge 2024-09-11 11-41-27.mp4", // Example path for document
      games: [
        GameTypes.triviaQuiz,
        // GameTypes.exoplanetBuilder,
      ],
    ),
    LevelModel(
      levelNumber: 3,
      learningType: "document",
      learningContent: "https://www.nasa.gov/documents-and-reports/",
      games: [
        GameTypes.matchingGame,
      ],
    ),
    // Add more levels here...
  ];
}
