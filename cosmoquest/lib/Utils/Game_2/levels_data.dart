import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/game_contants.dart';
import 'package:cosmoquest/Utils/apis.dart';

List<LevelModel> getLevelsData() {
  return [
    LevelModel(
      levelNumber: 1,
      title: "What is an Exoplanet?",
      subtitle: "Definition and basic understanding of exoplanets.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_1/Level 1 _ learning.mp4",
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
      title: "The Solar System vs. Exoplanetary Systems",
      subtitle: "Comparison of our solar system with exoplanetary systems.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_1/We Bee - Personal - Microsoft​ Edge 2024-09-11 11-41-27.mp4",
        ),
        LearningPart(
          type: "nasa_document",
          content: "https://api.nasa.gov/planetary/apod?api_key=${Apis.nasaApi}",
        ),
      ],
      games: [
        GameTypes.matchingGame,
      ],
    ),

    LevelModel(
      levelNumber: 3,
      title: "Methods of Exoplanet Detection",
      subtitle: "Detailed explanations of detection methods.",
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
