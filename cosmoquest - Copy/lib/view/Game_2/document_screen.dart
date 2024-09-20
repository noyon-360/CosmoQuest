

import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentScreen extends StatefulWidget {
  final LevelModel level;

  const DocumentScreen({super.key, required this.level});

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..loadRequest(Uri.parse("https://www.nasa.gov/documents-and-reports/")); // Load the URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}


// class GamesScreen extends StatelessWidget {
//   final LevelModel level;
//
//   const GamesScreen({super.key, required this.level});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Games Screen")),
//       body: ListView(
//         children: level.games.map((game) {
//           switch (game) {
//             case GameTypes.triviaQuiz:
//               return ListTile(
//                 title: Text("Trivia Quiz"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => TriviaQuizScreen(),
//                     ),
//                   );
//                 },
//               );
//             case GameTypes.matchingGame:
//               return ListTile(
//                 title: Text("Matching Game"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MatchingGameScreen(),
//                     ),
//                   );
//                 },
//               );
//             case GameTypes.puzzleChallenge:
//               return ListTile(
//                 title: Text("Puzzle Challenge"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PuzzleChallengeScreen(),
//                     ),
//                   );
//                 },
//               );
//             case GameTypes.memoryGame:
//               return ListTile(
//                 title: Text("Memory Game"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MemoryGameScreen(),
//                     ),
//                   );
//                 },
//               );
//             case GameTypes.exoplanetBuilder:
//               return ListTile(
//                 title: Text("Exoplanet Builder"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ExoplanetBuilderScreen(),
//                     ),
//                   );
//                 },
//               );
//             case GameTypes.spaceAdventureGame:
//               return ListTile(
//                 title: Text("Space Adventure Game"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SpaceAdventureGameScreen(),
//                     ),
//                   );
//                 },
//               );
//             default:
//               return Container();
//           }
//         }).toList(),
//       ),
//     );
//   }
// }
