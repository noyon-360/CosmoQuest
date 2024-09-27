class QuizRating {
  final int _totalQuestions = 10;
  final int _maxRating = 3;
  int _correctAnswers = 0;

  void submitAnswer(bool isCorrect) {
    if (isCorrect) {
      _correctAnswers++;
    }
  }

  int calculateRating() {
    double rating = (_correctAnswers / _totalQuestions) * _maxRating;
    return rating.round();
  }


  String getAchievement(double averageRating) {
    if (averageRating >= 2.5){
      return "Gold Achievement";
    }
    else if (averageRating >= 1.5) {
      return "Silver Achievement";
    }
    else {
      return "Bronze Achievement";
    }
  }
}