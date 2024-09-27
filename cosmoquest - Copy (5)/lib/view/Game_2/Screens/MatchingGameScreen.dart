
import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';


class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  // List of planet names and their corresponding images
  final List<String> planetNames = [
    'Mercury',
    'Venus',
    'Earth',
    'Mars',
    'Jupiter',
    'Saturn',
    'Uranus',
    'Neptune',
    'Pluto',
    'Sun',
  ];

  final Map<String, String> planetImages = {
    'Mercury': 'assets/containers/1.png',
    'Venus': 'assets/containers/1.png',
    'Earth': 'assets/containers/1.png',
    'Mars': 'assets/containers/1.png',
    'Jupiter': 'assets/containers/1.png',
    'Saturn': 'assets/containers/1.png',
    'Uranus': 'assets/containers/1.png',
    'Neptune': 'assets/containers/1.png',
    'Pluto': 'assets/containers/1.png',
    'Sun': 'assets/containers/1.png',
  };

  // This will hold the dragged image
  String? draggedImage;

  // To track matched results
  Map<String, bool> results = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Planets with Names'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.0,
              ),
              itemCount: planetImages.length,
              itemBuilder: (context, index) {
                String planet = planetNames[index];
                return Draggable<String>(
                  data: planet,
                  feedback: Image.asset(
                    planetImages[planet]!,
                    width: 100,
                    height: 100,
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      planetImages[planet]!,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  child: Image.asset(
                    planetImages[planet]!,
                    width: 100,
                    height: 100,
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: planetNames.length,
              itemBuilder: (context, index) {
                String planet = planetNames[index];
                return DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      color: results[planet] == true
                          ? Colors.green
                          : Colors.grey[200],
                      child: Text(
                        planet,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  onWillAccept: (data) => data == planet,
                  onAccept: (data) {
                    setState(() {
                      results[planet] = true;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              int correct = results.values.where((v) => v == true).length;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Results'),
                  content: Text('You matched $correct/${planetNames.length} planets correctly!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Check Results'),
          ),
        ],
      ),
    );
  }
}


