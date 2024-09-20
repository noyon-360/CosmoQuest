// import 'package:cosmoquest/ViewModel/Game_2/learning_viewmodel.dart';
// import 'package:cosmoquest/view/Game_2/Screens/ExoplanetBuilderScreen.dart';
// import 'package:cosmoquest/view/Game_2/Screens/MatchingGameScreen.dart';
// import 'package:cosmoquest/view/Game_2/Screens/MemoryGameScreen.dart';
// import 'package:cosmoquest/view/Game_2/Screens/PuzzleChallengeScreen.dart';
// import 'package:cosmoquest/view/Game_2/Screens/SpaceAdventureGameScreen.dart';
// import 'package:cosmoquest/view/Game_2/Screens/TriviaQuizScreen.dart';
// import 'package:cosmoquest/view/Game_2/document_screen.dart';
// import 'package:cosmoquest/view/Video/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class LearningPage extends StatelessWidget {
//   final int levelNumber;
//   const LearningPage({super.key, required this.levelNumber});
//
//   @override
//   Widget build(BuildContext context) {
//     final learningVM = Provider.of<LearningViewModel>(context);
//
//     learningVM.loadLevel(levelNumber);
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Level ${learningVM.currentLevelNumber}"),),
//       body: Column(
//         children: [
//           // learningVM.isVideoLearning() ? VideoPlayerScreen(level: ) : DocumentViewer(),
//
//           SizedBox(height: 20,),
//
//           Expanded(child: ListView.builder(
//             itemCount: learningVM.getLevelGames().length,
//               itemBuilder: (context, index){
//             return ListTile(
//               title: Text(learningVM.getLevelGames()[index]),
//               onTap: (){
//                 String game = learningVM.getLevelGames()[index];
//                 switch (game) {
//                   case 'Trivia Quiz':
//                     // Navigator.pushNamed(context, '/trivia');
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => TriviaQuizScreen()));
//                     break;
//                   case 'Matching Game':
//                     // Navigator.pushNamed(context, '/matching');
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => MatchingGameScreen()));
//                     break;
//                   case 'Puzzle Challenge':
//                     // Navigator.pushNamed(context, '/puzzle');
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => PuzzleChallengeScreen()));
//                     break;
//                   case 'Memory Game':
//                     // Navigator.pushNamed(context, '/memory');
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryGameScreen()));
//                     break;
//                   case 'Exoplanet Builder':
//                     // Navigator.pushNamed(context, '/exoplanet');
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ExoplanetBuilderScreen()));
//                     break;
//                   case 'Space Adventure Game':
//                     // Navigator.pushNamed(context, '/spaceAdventure');
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => SpaceAdventureGameScreen()));
//                     break;
//                   default:
//                     break;
//                 }
//               },
//             );
//           }))
//         ],
//       ),
//     );
//   }
// }
