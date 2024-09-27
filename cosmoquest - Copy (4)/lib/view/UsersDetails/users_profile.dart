import 'package:flutter/material.dart';

class UsersProfile extends StatelessWidget {
  final String photoUrl;
  final String name;
  final String email;
  final int level;
  final Map<String, int> ratings;

  const UsersProfile(
      {super.key,
      required this.photoUrl,
      required this.name,
      required this.email,
      required this.level,
      required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name ?? 'User Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl!) : null,
                  backgroundColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              // User details
              Text("Name: ${name ?? "Unknown"}",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("Email: ${email ?? "Unknown"}",
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text("Level: $level", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),

              // Ratings for all levels
              const Text("Ratings for Levels:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    String level = ratings.keys.elementAt(index);
                    int rating = ratings[level]!;
                    return ListTile(
                      title: Text("Level $level"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (starIndex) {
                          return Icon(
                            starIndex < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
