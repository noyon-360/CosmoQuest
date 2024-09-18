import 'package:cosmoquest/ViewModel/GameQuiz/quiz_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cosmoquest/ViewModel/GameQuiz/QuizViewModel.dart';

class QuizScreen extends StatelessWidget {
  final Function(bool passed) onQuizCompleted;

  const QuizScreen({super.key, required this.onQuizCompleted});

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context);

    // Check if there are questions before accessing the first question
    if (quizViewModel.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Astrology NASA Quiz'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Load the Astrology NASA quiz before navigating to the QuizScreen
              Provider.of<QuizViewModel>(context, listen: false).loadAstrologyNASAQuiz();

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => QuizScreen()),
              // );
            },
            child: Text('Start Quiz'),
          )

        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Astrology NASA Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quizViewModel.currentQuestion.question,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            ...quizViewModel.currentQuestion.options.map((option) => ElevatedButton(
              onPressed: () {
                quizViewModel.answerQuestion(option, context);
              },
              child: Text(option),
            )),
            SizedBox(height: 20),
            Text(
              'Correct Answers: ${quizViewModel.correctAnswers}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
