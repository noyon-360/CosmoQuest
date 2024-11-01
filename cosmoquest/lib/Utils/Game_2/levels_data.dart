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
          content: "https://science.nasa.gov/exoplanets/",
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
          content: "/game/level_2/The_Solar_System_vs_Exoplanets.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://www.jpl.nasa.gov/news/news.php?feature=7420",
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
          type: "article",
          content: "/game/level_3/Methods_of_Exoplanet_Detection.pdf",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/resources/401/how-do-we-find-exoplanets/",
        ),
      ],
      games: [
        GameTypes.puzzleChallenge,
      ],
    ),

    LevelModel(
      levelNumber: 4,
      title: "The Transit Method",
      subtitle: "Deep dive into the transit method.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_4/The_Transit_Method.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/23/what-is-the-transit-method/",
        ),
      ],
      games: [
        GameTypes.memoryGame,
      ],
    ),

    LevelModel(
      levelNumber: 5,
      title: "The Radial Velocity Method",
      subtitle: "Understanding the radial velocity method.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_5/The_Radial_Velocity_Method.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/24/what-is-the-radial-velocity-method/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 6,
      title: "The Direct Imaging Method",
      subtitle: "Challenges and advancements in direct imaging.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_6/The_Direct_Imaging_Method.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/25/what-is-direct-imaging/",
        ),
      ],
      games: [
        GameTypes.memoryGame,
      ],
    ),

    LevelModel(
      levelNumber: 7,
      title: "The Gravitational Microlensing Method",
      subtitle: "How gravitational microlensing works.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_7/Gravitational_Microlensing_Method.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/26/what-is-gravitational-microlensing/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 8,
      title: "Exoplanet Atmospheres",
      subtitle: "How scientists study exoplanet atmospheres.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_8/Exoplanet_Atmospheres.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/27/how-do-scientists-study-exoplanet-atmospheres/",
        ),
      ],
      games: [
        GameTypes.spaceAdventureGame,
      ],
    ),

    LevelModel(
      levelNumber: 9,
      title: "Habitable Zones",
      subtitle: "The concept of habitable zones or 'Goldilocks zones.'",
      learningParts: [
        LearningPart(
          type: "article",
          content: "/game/level_9/Habitable_Zones.pdf",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/28/what-is-a-habitable-zone/",
        ),
      ],
      games: [
        GameTypes.exoplanetBuilder,
      ],
    ),

    LevelModel(
      levelNumber: 10,
      title: "Super-Earths and Mini-Neptunes",
      subtitle: "Characteristics of these types of exoplanets.",
      learningParts: [
        LearningPart(
          type: "article",
          content: "/game/level_10/Super_Earths_and_Mini_Neptunes.pdf",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/29/what-are-super-earths-and-mini-neptunes/",
        ),
      ],
      games: [
        GameTypes.matchingGame,
      ],
    ),

    LevelModel(
      levelNumber: 11,
      title: "Hot Jupiters",
      subtitle: "Understanding these massive, close-orbiting exoplanets.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_11/Hot_Jupiters.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/30/what-are-hot-jupiters/",
        ),
      ],
      games: [
        GameTypes.matchingGame,
      ],
    ),

    LevelModel(
      levelNumber: 12,
      title: "Exoplanetary Moons (Exomoons)",
      subtitle: "The search for moons around exoplanets.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_12/Exoplanetary_Moons.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/31/what-are-exomoons/",
        ),
      ],
      games: [
        GameTypes.matchingGame,
      ],
    ),

    LevelModel(
      levelNumber: 13,
      title: "Rogue Planets",
      subtitle: "Planets that drift through space without a host star.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_13/Rogue_Planets.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/32/what-are-rogue-planets/",
        ),
      ],
      games: [
        GameTypes.matchingGame,
      ],
    ),

    LevelModel(
      levelNumber: 14,
      title: "The Kepler Mission",
      subtitle: "The role of the Kepler Space Telescope in exoplanet discovery.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_14/Kepler_Mission.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/33/what-is-the-kepler-mission/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 15,
      title: "The TESS Mission",
      subtitle: "How the Transiting Exoplanet Survey Satellite continues the search.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_15/TESS_Mission.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/34/what-is-the-tess-mission/",
        ),
      ],
      games: [
        GameTypes.memoryGame,
      ],
    ),

    LevelModel(
      levelNumber: 16,
      title: "The James Webb Space Telescope",
      subtitle: "Expected contributions to exoplanetary science.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_16/JWST.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/35/what-is-the-james-webb-space-telescope/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 17,
      title: "SETI and the Search for Extraterrestrial Life",
      subtitle: "The role of exoplanets in the search for life beyond Earth.",
      learningParts: [
        LearningPart(
          type: "video",
          content: "/game/level_17/SETI.mp4",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/36/what-is-seti/",
        ),
      ],
      games: [
        GameTypes.memoryGame,
      ],
    ),

    LevelModel(
      levelNumber: 18,
      title: "Future Missions in Exoplanet Exploration",
      subtitle: "Upcoming telescopes and missions.",
      learningParts: [
        LearningPart(
          type: "article",
          content: "/game/level_18/Future_Missions.pdf",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/37/what-are-the-future-missions/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 19,
      title: "Ethical Considerations in Exoplanet Exploration",
      subtitle: "Discuss the ethics of space exploration and potential colonization.",
      learningParts: [
        LearningPart(
          type: "article",
          content: "/game/level_19/Ethical_Considerations.pdf",
        ),
        LearningPart(
          type: "document",
          content: "https://exoplanets.nasa.gov/learn/faq/38/what-are-the-ethical-considerations/",
        ),
      ],
      games: [
        GameTypes.triviaQuiz,
      ],
    ),

    LevelModel(
      levelNumber: 20,
      title: "Summary and Final Assessment",
      subtitle: "Review of key concepts learned.",
      learningParts: [
        LearningPart(
          type: "article",
          content: "/game/level_20/Summary_and_Final_Assessment.pdf",
        ),
      ],
      games: [
        GameTypes.memoryGame,
      ],
    ),
  ];
}
