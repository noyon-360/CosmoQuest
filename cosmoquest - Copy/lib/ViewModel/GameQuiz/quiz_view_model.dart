// lib/ViewModel/QuizViewModel.dart
import 'package:audioplayers/audioplayers.dart';
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

  QuizRating _rating = QuizRating();

  QuizQuestion get currentQuestion {
    if (_questions.isEmpty) {
      throw StateError('No questions available');
    }
    return _questions[_currentQuestionIndex];
  }

  List<QuizQuestion> get questions => _questions;



  Future<void> loadQuestions(List<QuizQuestion> questions) async {
    _questions = questions;
    _currentQuestionIndex = 0;
    correctAnswers = 0;
    _rating = QuizRating();
    notifyListeners();
  }

  Future<void> loadAstrologyNASAQuiz(int level) async {
    List<QuizQuestion> questions = [];
    if (level == 1) {
      questions = astrologyNASAQuestions;
    } else if (level == 2) {
      questions = astrologyQuestions;
    }
    await loadQuestions(questions);
  }


  Future<void> answerQuestion(String answer, BuildContext context) async {
    if (_questions.isEmpty) return;

    if (_questions[_currentQuestionIndex].correctAnswer == answer) {
      correctAnswers++;
      _rating.submitAnswer(true);
    }
    else {
      _rating.submitAnswer(false);
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      await checkForNextLevel(context);
    }
  }

  int _calculateRating(int correctAnswer){
    if (correctAnswer >= 9) return 3;
    if (correctAnswer >= 6) return 2;
    return 1;
  }

  Future<void> checkForNextLevel(BuildContext context) async {
    bool passed = correctAnswers >= 6;
    final userProgressLocalStore = UserProgressLocalStore();
    final userProgressFireStore = UserProgressFireStore();

    int currentLevel = await userProgressLocalStore.getLevel();
    int rating = _calculateRating(correctAnswers);

    if (passed) {
      await userProgressLocalStore.saveLevel(currentLevel + 1);
      await userProgressFireStore.saveLevel(currentLevel + 1);
    }

    await userProgressLocalStore.saveRating(currentLevel, rating);
    await userProgressFireStore.saveRating(currentLevel, rating);

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



