class Planet {
  final String name;
  final double radius;
  final double starTemp;
  final double orbitalDistance;
  final String imageUrl;

  Planet({required this.name, required this.radius, required this.starTemp, required this.orbitalDistance, required this.imageUrl});

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['pl_name'],
      radius: json['pl_rade'],
      starTemp: json['st_teff'],
      orbitalDistance: json['pl_orbsmax'],
      imageUrl: json['image_url'] ?? 'https://science.nasa.gov/wp-content/uploads/2023/04/hs-2016-32-a-print-crop-jpg.webp?w=2048&format=webp',
    );
  }
}
