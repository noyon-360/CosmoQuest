// lib/ViewModel/QuizViewModel.dart

import 'package:cosmoquest/Model/quiz_rating_model.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/ViewModel/GameQuiz/QuizQuestion.dart';
import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Game/NextLevel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosmoquest/Model/QuizQuestion.dart';

class QuizViewModel extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int correctAnswers = 0;


  // String? selectedAnswer;

  List<String?> _selectedAnswer = [];

  QuizRating _rating = QuizRating();

  QuizQuestion get currentQuestion {
    if (_questions.isEmpty) {
      throw StateError('No questions available');
    }
    return _questions[currentQuestionIndex];
  }

  // QuizQuestion get currentQuestion => _questions[_currentQuestionIndex];
  int get currentQuestionIndex => _currentQuestionIndex;
  List<QuizQuestion> get questions => _questions;

  // bool get isLastQuestion => currentQuestionIndex == _questions.length - 1;


  Future<void> loadQuestions(List<QuizQuestion> questions) async {
    _questions = questions;
    _selectedAnswer = List<String?>.filled(questions.length, null);
    _currentQuestionIndex = 0;
    correctAnswers = 0;
    // _rating = QuizRating();
    notifyListeners();
  }

  Future<void> checkUserLevelQuiz(int level) async {
    List<QuizQuestion> questions = [];
    if (level == 1) {
      questions = level1QA;
    } else if (level == 2) {
      questions = astrologyQuestions;
    }
    else if (level == 5) {
      questions = level5QA;
    }
    await loadQuestions(questions);
  }

  void selectAnswer(String answer) {
    _selectedAnswer[_currentQuestionIndex] = answer;
    notifyListeners();
  }

  bool isCorrectAnswer(String selectedOption) {
    return currentQuestion.correctAnswer == selectedOption;
  }

  bool isSelected(String options) {
    return _selectedAnswer[_currentQuestionIndex] == options;
  }


  bool isOptionSelected () {
    return _selectedAnswer[_currentQuestionIndex] != null;
  }

  void nextQuestion() {
    if(_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }

    // currentQuestionIndex++;
    // selectedAnswer = null;
    // notifyListeners();
  }

  void previousQuestion(){
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      // selectedAnswer = null;
      notifyListeners();
    }
  }

  Future<void> submitQuiz(BuildContext context, level) async {
    correctAnswers = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswer[i] == _questions[i].correctAnswer){
        correctAnswers++;
      }
    }

    await checkForNextLevel(context, level);
  }


  Future<void> answerQuestion(String answer, level, BuildContext context) async {
    if (_questions.isEmpty) return;

    if (_questions[currentQuestionIndex].correctAnswer == answer) {
      correctAnswers++;
      _rating.submitAnswer(true);
    }
    else {
      _rating.submitAnswer(false);
    }

    if (currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      await checkForNextLevel(context, level);
    }
  }

  int _calculateRating(int correctAnswer){
    if (correctAnswer >= 9) return 3;
    if (correctAnswer >= 6) return 2;
    return 1;
  }


  Future<void> checkForNextLevel(BuildContext context, level) async {
    bool passed = correctAnswers >= 6;
    final userProgressLocalStore = UserProgressLocalStore();
    final userProgressFireStore = UserProgressFireStore();

    // int currentLevel = await userProgressLocalStore.getLevel();
    int currentLevel = level - 1;
    print(currentLevel);
    int rating = _calculateRating(correctAnswers);
    int score = correctAnswers;

    if (passed) {
      await userProgressLocalStore.saveLevel(currentLevel + 1);
      await userProgressFireStore.saveLevel(currentLevel + 1);
    }

    await userProgressLocalStore.saveRating(currentLevel, rating);
    await userProgressFireStore.saveRatingAndScore(currentLevel, rating, score);
    // await userProgressFireStore.saveRating(currentLevel, score);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NextLevelScreen(
          passed: passed,
          rating: rating,
          onNextLevel: () => _navigateTo(context, const BottomNavigationBarHome()),
          onRetry: () => _navigateTo(context, const BottomNavigationBarHome()),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
          (route) => false, // Removes all previous routes
    );
  }

}



