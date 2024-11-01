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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Trivia Quiz"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.preview_outlined),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            Center(
              child: Text(
                'Question ${quizViewModel.currentQuestionIndex + 1}/${quizViewModel.questions.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10,),
            LinearProgressIndicator(
              value: (quizViewModel.currentQuestionIndex + 1) / quizViewModel.questions.length,
              backgroundColor: Colors.white12,
              color: Colors.deepPurpleAccent,
            ),
            const SizedBox(height: 20),

            // Question Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.edit,
                    color: Colors.deepPurpleAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      quizViewModel.currentQuestion.question,
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Options Container
            // Options Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: quizViewModel.currentQuestion.options.map((option) {
                  final isSelected = quizViewModel.isSelected(option);
                  final isCorrect = quizViewModel.isCorrectAnswer(option);
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? isCorrect ? Colors.green : Colors.red
                          : Colors.white24,
                    ),
                    onPressed: () {
                      quizViewModel.selectAnswer(option);
                      Future.delayed(const Duration(seconds: 1), () {
                        if (quizViewModel.isOptionSelected()) {
                          if (quizViewModel.currentQuestionIndex < quizViewModel.questions.length - 1) {
                            quizViewModel.nextQuestion();
                          } else {
                            quizViewModel.submitQuiz(context, widget.level.levelNumber);
                          }
                        }
                      });
                    },
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Navigation Buttons
            // Row(
            //   children: [
            //     if (quizViewModel.currentQuestionIndex > 0)
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.deepPurpleAccent,
            //           ),
            //           onPressed: quizViewModel.previousQuestion,
            //           label: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(Icons.arrow_back_ios, color: Colors.white),
            //               SizedBox(width: 10,),
            //               const Text("Previous", style: TextStyle(color: Colors.white)),
            //             ],
            //           ),
            //         ),
            //       ),
            //     SizedBox(width: 10,),
            //     if (quizViewModel.currentQuestionIndex < quizViewModel.questions.length - 1)
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.deepPurpleAccent,
            //           ),
            //           onPressed: () {
            //             if (quizViewModel.isOptionSelected()) {quizViewModel.nextQuestion();
            //             } else {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                   content: Text(
            //                       'Please select an option before proceeding.'),
            //                   backgroundColor: Colors.red,
            //                 ),
            //               );
            //             }
            //           },
            //           label: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               const Text("Next", style: TextStyle(color: Colors.white)),
            //               SizedBox(width: 10,),
            //               Icon(Icons.arrow_forward_ios, color: Colors.white)
            //             ],
            //           ),
            //         ),
            //       ),
            //     if (quizViewModel.currentQuestionIndex == quizViewModel.questions.length - 1)
            //       Expanded(
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.green,
            //           ),
            //           onPressed: () {
            //             if (quizViewModel.isOptionSelected()) {
            //               quizViewModel.submitQuiz(context, widget.level.levelNumber);
            //             } else {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                   content: Text('Please select an option before submitting.'),
            //                   backgroundColor: Colors.red,
            //                 ),
            //               );
            //             }
            //           },
            //           child: const Text("Submit", style: TextStyle(color: Colors.white)),
            //         ),
            //       ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
