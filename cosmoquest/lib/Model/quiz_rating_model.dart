class Quiz {
  int _totalQuestions = 10;
  int _maxRating = 3;
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
}