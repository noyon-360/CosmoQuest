class Article {
  final String title;
  final String date;
  final String explanation;
  final String hdUrl; // High-definition URL
  final String url;    // Regular image URL
  final String copyright;

  Article({
    required this.title,
    required this.date,
    required this.explanation,
    required this.hdUrl,
    required this.url,
    required this.copyright,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      date: json['date'],
      explanation: json['explanation'],
      hdUrl: json['hdurl'],
      url: json['url'],
      copyright: json['copyright'].trim(), // Trim to remove excess whitespace
    );
  }
}
