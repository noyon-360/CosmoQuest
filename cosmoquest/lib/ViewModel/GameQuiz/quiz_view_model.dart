import 'package:cosmoquest/Model/QuizQuestion.dart';
import 'package:cosmoquest/ViewModel/GameQuiz/QuizQuestion.dart';
import 'package:cosmoquest/view/Game/NextLevel.dart';
import 'package:flutter/material.dart';

class QuizViewModel extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int correctAnswers = 0;

  // Getter for current question
  QuizQuestion get currentQuestion => _questions[_currentQuestionIndex];

  // Getter for all questions
  List<QuizQuestion> get questions => _questions;

  // Initialize with some questions
  void loadQuestions(List<QuizQuestion> questions) {
    _questions = questions;
    _currentQuestionIndex = 0;
    correctAnswers = 0;
    notifyListeners();
  }

  // Load Astrology NASA questions
  void loadAstrologyNASAQuiz() {
    loadQuestions(astrologyNASAQuestions);
  }

  // Check the answer and move to the next question
  void answerQuestion(String answer, BuildContext context) {
    if (_questions[_currentQuestionIndex].correctAnswer == answer) {
      correctAnswers++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      checkForNextLevel(context);
    }
  }

  // Logic to check if the user passes to the next level
  void checkForNextLevel(BuildContext context) {
    bool passed = correctAnswers >= 7;

    // Navigate to the next level screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NextLevelScreen(

          passed: passed,
          onNextLevel: () {
            if (passed) {
              loadNextLevel();
            } else {
              retryLevel();
            }
            Navigator.pop(context); // Go back to the QuizScreen
          }, onRetry: () {  }, onQuizCompleted: (bool passed) {  },
        ),
      ),
    );
  }

  // Logic to load the next level
  void loadNextLevel() {
    // You would replace this with actual logic for loading the next level's questions
    // For now, we'll just reset the quiz with the same questions for demonstration
    loadAstrologyNASAQuiz();
  }

  // Logic to retry the current level
  void retryLevel() {
    loadQuestions(_questions); // Restart the current level
  }
}
