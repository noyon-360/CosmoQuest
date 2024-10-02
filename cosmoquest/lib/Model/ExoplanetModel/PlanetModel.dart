class Planet {
  final String name;
  final double radius;
  final double starTemp;
  final double orbitRadius;

  Planet({
    required this.name,
    required this.radius,
    required this.starTemp,
    required this.orbitRadius,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['pl_name'] ?? 'Unknown',                 // Handle null for name
      radius: (json['pl_rade'] != null ? json['pl_rade'].toDouble() : 0), // Handle null for radius
      starTemp: (json['st_teff'] != null ? json['st_teff'].toDouble() : 0), // Handle null for starTemp
      orbitRadius: (json['pl_orbsmax'] != null ? json['pl_orbsmax'].toDouble() : 0), // Handle null for orbitRadius
    );
  }
}
