class APODData {
  final String date;
  final String title;
  final String explanation;
  final String url;
  final String hdurl;
  final String copyright;

  APODData({
    required this.date,
    required this.title,
    required this.explanation,
    required this.url,
    required this.hdurl,
    required this.copyright,
  });

  factory APODData.fromJson(Map<String, dynamic> json) {
    return APODData(
      date: json['date'] ?? 'No date available', // Handle null for 'date'
      title: json['title'] ?? 'No title available', // Handle null for 'title'
      explanation: json['explanation'] ?? 'No explanation available', // Handle null for 'explanation'
      url: json['url'] ?? 'https://example.com/placeholder.jpg', // Handle null for 'url' with a placeholder image
      hdurl: json['hdurl'] ?? 'https://example.com/placeholder_hd.jpg', // Handle null for 'hdurl' with a placeholder image
      copyright: json['copyright'] ?? 'Public Domain', // Handle null for 'copyright'
    );
  }
}
