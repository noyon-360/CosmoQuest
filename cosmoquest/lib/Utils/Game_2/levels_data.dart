import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/game_contants.dart';

List<LevelModel> getLevelsData() {
  return [
    LevelModel(
      levelNumber: 1,
      learningType: "video",
      learningContent: "https://example.com/video1.mp4", // Example URL for video
      games: [
        GameTypes.triviaQuiz,
        GameTypes.puzzleChallenge,
      ],
    ),
    LevelModel(
      levelNumber: 2,
      learningType: "document",
      learningContent: "/assets/docs/level2.pdf", // Example path for document
      games: [
        GameTypes.memoryGame,
        GameTypes.exoplanetBuilder,
      ],
    ),
    LevelModel(
      levelNumber: 3,
      learningType: "video",
      learningContent: "https://example.com/video3.mp4",
      games: [
        GameTypes.matchingGame,
        GameTypes.spaceAdventureGame,
      ],
    ),
    // Add more levels here...
  ];
}
