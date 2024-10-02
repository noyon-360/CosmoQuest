import 'dart:math';

import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {

  @override
  void initState() {
    super.initState();
    currentPlanet = planetNames[Random().nextInt(planetNames.length)];
  }

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
    // 'Pluto',
    // 'Sun',
  ];

  final Map<String, String> planetImages = {
    'Mercury': 'assets/images/Planet-_Mercury.png',
    'Venus': 'assets/images/Planet-_Venus.png',
    'Earth': 'assets/images/Planet-_Earth.png',
    'Mars': 'assets/images/Planet-_Mars.png',
    'Jupiter': 'assets/images/Planet-_Jupiter.png',
    'Saturn': 'assets/images/Planet-_Saturn.png',
    'Uranus': 'assets/images/Planet-_Uranus.png',
    'Neptune': 'assets/images/Planet-_Neptune.png',
    // 'Pluto': 'assets/containers/1.png',
    // 'Sun': 'assets/containers/1.png',
  };

  // This will hold the current planet being dragged
  String? currentPlanet;

  // To track matched results
  Map<String, bool> results = {};

  // To track the offset of the draggable image
  Offset? _offset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Planets with Names'),
      ),
      body: Column(
        children: [
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
                          : results[planet] == false
                          ? Colors.red
                          : Colors.grey[200],
                      child: Text(
                        planet,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  onWillAccept: (data) => true,
                  onAccept: (data) {
                    setState(() {
                      if (data == planet) {
                        results[planet] = true;
                      } else {
                        results[planet] = false;
                      }
                      getNextPlanet();
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                if (currentPlanet != null)
                  Align(
                    alignment: Alignment.center,
                    child: Draggable<String>(
                      data: currentPlanet,
                      feedback: Image.asset(
                        planetImages[currentPlanet]!,
                        width: 100,
                        height: 100,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          planetImages[currentPlanet]!,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _offset = Offset(_offset?.dx ?? 0 + details.delta.dx, _offset?.dy ?? 0 + details.delta.dy);
                          });
                        },
                        child: Image.asset(
                          planetImages[currentPlanet]!,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      onDragEnd: (details) {
                        setState(() {
                          _offset = null;
                          getNextPlanet();
                        });
                      },
                    ),
                  ),
              ],
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

  void getNextPlanet() {
    if (results.length < planetNames.length) {
      List<String> remainingPlanets = planetNames.where((p) => !results.containsKey(p)).toList();
      currentPlanet = remainingPlanets[Random().nextInt(remainingPlanets.length)];
    } else {
      currentPlanet = null; // No more planets to match
    }
  }
}