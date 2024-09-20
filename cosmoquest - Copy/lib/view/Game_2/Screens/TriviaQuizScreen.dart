import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ViewModel/GameQuiz/quiz_view_model.dart';

class TriviaQuizScreen extends StatefulWidget {
  final LevelModel level;

  const TriviaQuizScreen({super.key, required this.level});

  @override
  _TriviaQuizScreenState createState() => _TriviaQuizScreenState();
}

class _TriviaQuizScreenState extends State<TriviaQuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      quizViewModel.loadAstrologyNASAQuiz(widget.level.levelNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Trivia Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quizViewModel.currentQuestion.question,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...quizViewModel.currentQuestion.options.map((option) => ElevatedButton(
              onPressed: () {
                quizViewModel.answerQuestion(option, context);
              },
              child: Text(option),
            )).toList(),
            const SizedBox(height: 20),
            Text(
              'Correct Answers: ${quizViewModel.correctAnswers}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
