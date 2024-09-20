class LevelModel {
  final int levelNumber;
  final String learningType; // "video" or "document"
  final String learningContent; // URL for video or path for document
  final List<String> games; // List of games for this level

  LevelModel({
    required this.levelNumber,
    required this.learningType,
    required this.learningContent,
    required this.games,
  });
}
