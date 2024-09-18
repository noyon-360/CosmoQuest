import 'dart:ui';

import 'package:flutter/material.dart';

class GameHome extends StatefulWidget {
  const GameHome({super.key});

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Background/GameHome.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Blur effect
              child: Container(
                color: Colors.black.withOpacity(0.4), // Optional overlay with opacity
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width ,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Home Title.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                ),
                const SizedBox(
                  height: 20,
                ),

                _buildLevelButton("Easy"),
                const SizedBox(
                  height: 10,
                ),
                _buildLevelButton("Medium"),
                const SizedBox(
                  height: 10,
                ),
                _buildLevelButton("Hard"),



              ],
            ),
          ),
        ],

      ),
    );

  }
  Widget _buildLevelButton(String value){
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0), // Remove the default shadow
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
            side: const BorderSide(color: Colors.white, width: 2), // White border
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.blueAccent.withOpacity(0.5)), // Add a blue glow-like shadow
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 44)), // Padding inside button
      ),
      onPressed: () {
        // Your button action here
      },
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white, // Text color
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow( // Adding a glow effect to the text
              offset: Offset(0, 0),
              blurRadius: 8.0,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );

  }
}
