import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/view/Game_2/Screens/GameScreen.dart';
import 'package:cosmoquest/view/Game_2/document_screen.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  final String learningContent;
  final LevelModel level;

  const LearningScreen({
    super.key,
    required this.learningContent,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learning Screen")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display learning content
          if (level.learningType == "video")
            SizedBox(
              height: 200,
              child: VideoPlayerScreen(level: level),)
            // Text("Video: $learningContent") // Replace with actual video player widget
          else if (level.learningType == "document")
            DocumentScreen(level: level),
            // Text("Document: $learningContent"), // Replace with actual document viewer widget

          const Spacer(),

          // Next Button
          ElevatedButton(
            onPressed: () {
              // Navigate to games based on level's games
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GamesScreen(level: level),
                ),
              );
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
