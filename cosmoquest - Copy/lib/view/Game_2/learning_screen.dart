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
            Expanded(child: VideoPlayerScreen(level: level, videoPath: learningContent,))
            // Text("Video: $learningContent") // Replace with actual video player widget
          else if (level.learningType == "document")
            SizedBox(
                height: 500,
                child: DocumentScreen(level: level)),
            // Text("Document: $learningContent"), // Replace with actual document viewer widget

          const Spacer(),
        ],
      ),
      // Next button
      floatingActionButton: SizedBox(
        width: 100, // Increase the width
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GamesScreen(level: level, ),
              ),
            );
          },
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners for wide button
          ),
          elevation: 10,
          child: const Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Next",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Icon(Icons.navigate_next, color: Colors.white, size: 24,),
            ],
          ), // Add glow effect
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
