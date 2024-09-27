import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/game_contants.dart';

List<LevelModel> getLevelsData() {
  return [
    LevelModel(
      levelNumber: 1,
      title: "What is an Exoplanet?",
      subtitle: "Definition and basic understanding of exoplanets.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_1/We Bee - Personal - Microsoft​ Edge 2024-09-11 11-41-27.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://www.nasa.gov/documents-and-reports/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 2,
      title: "The Solar System \nvs.\nExoplanetary Systems",
      subtitle: "Comparison of our solar system with exoplanetary systems.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_1/We Bee - Personal - Microsoft​ Edge 2024-09-11 11-41-27.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://www.nasa.gov/documents-and-reports/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

  ];
}
