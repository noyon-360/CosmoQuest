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
      quizViewModel.checkUserLevelQuiz(widget.level.levelNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Trivia Quiz"),
              actions: [Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(onPressed: (){

                }, icon: const Icon(Icons.preview_outlined)),
              )],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Question ${quizViewModel.currentQuestionIndex + 1}/${quizViewModel.questions.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    quizViewModel.currentQuestion.question,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  ...quizViewModel.currentQuestion.options.map((option) {
                    final isSelected = quizViewModel.isSelected(option);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.deepPurple.shade300 : Colors.white,
                      ),
                      onPressed: () {
                        quizViewModel.selectAnswer(option);
                      },
                      child: Text(
                        option,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),

                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (quizViewModel.currentQuestionIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: quizViewModel.previousQuestion,
                      child: const Text("Previous"),
                    ),
                  ),
                if (quizViewModel.currentQuestionIndex <
                    quizViewModel.questions.length - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (quizViewModel.isOptionSelected()) {
                          quizViewModel.nextQuestion();
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select an option before proceeding.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Next"),
                    ),
                  ),
                if (quizViewModel.currentQuestionIndex ==
                    quizViewModel.questions.length - 1)
                  Expanded(child:
                  ElevatedButton(
                    onPressed: () {
                      if (quizViewModel.isOptionSelected()) {
                        quizViewModel.submitQuiz(context, widget.level.levelNumber);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('Please select an option before submitting.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                  )
              ],
            ),

            const SizedBox(height: 20),
            // Text(
            //   'Correct Answers: ${quizViewModel.correctAnswers}',
            //   style: const TextStyle(fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}
