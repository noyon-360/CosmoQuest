class LearningPart {

  final String type; // "video" or "document"
  final String content; // Path or URL

  LearningPart({

    required this.type,
    required this.content,
  });
}

class LevelModel {
  final int levelNumber;
  final String title;
  final String subtitle;
  final List<LearningPart> learningParts;
  final List<String> games; // List of games for this level

  LevelModel({
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.learningParts,
    required this.games,
  });
}
