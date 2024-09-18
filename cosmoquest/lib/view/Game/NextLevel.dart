import 'package:flutter/material.dart';

class NextLevelScreen extends StatefulWidget {
  final Function(bool passed) onQuizCompleted;
  final bool passed;
  final VoidCallback onNextLevel;
  final VoidCallback onRetry;

  const NextLevelScreen({super.key, required this.onQuizCompleted, required this.passed, required this.onNextLevel, required this.onRetry});

  @override
  State<NextLevelScreen> createState() => _NextLevelScreenState();
}

class _NextLevelScreenState extends State<NextLevelScreen> {
  bool quizPassed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.passed ? 'Level Complete' : 'Level Failed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.passed
                  ? 'Congratulations! You passed this level!'
                  : 'Sorry, you didn\'t pass this level.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              widget.passed
                  ? 'Get ready for the next level!'
                  : 'You can retry the level to improve your score.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: widget.passed ? widget.onNextLevel : widget.onRetry,
              child: Text(widget.passed ? 'Start Next Level' : 'Retry Level'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            if (widget.passed)
              ElevatedButton(
                onPressed: () {
                  widget.onQuizCompleted(quizPassed);
                  Navigator.pop(context); // Return to the home or level selection screen
                },
                child: Text('Return to Main Menu'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// class NextLevelScreen extends StatelessWidget {
//   final Function(bool passed) onQuizCompleted;
//   final bool passed;
//   final VoidCallback onNextLevel;
//   final VoidCallback onRetry;
//
//   const NextLevelScreen({
//     super.key,
//     required this.passed,
//     required this.onNextLevel,
//     required this.onRetry, required this.onQuizCompleted,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool quizPassed = true;
//
//   }
// }
