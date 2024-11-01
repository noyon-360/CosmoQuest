class GameRating {
  int _correctAnswers = 0;
  int _totalAttempts = 0;

  // Track each answer and increment counters based on the result
  void submitAnswer(bool isCorrect) {
    _totalAttempts++;
    if (isCorrect) {
      _correctAnswers++;
    }
  }

  // Getters for correct answers and attempts
  int get correctAnswers => _correctAnswers;
  int get totalAttempts => _totalAttempts;

  // Calculate the player's rating based on performance
  double get accuracy {
    if (_totalAttempts == 0) return 0.0;
    return (_correctAnswers / _totalAttempts) * 100;
  }

  // Reset rating
  void reset() {
    _correctAnswers = 0;
    _totalAttempts = 0;
  }

  @override
  String toString() {
    return 'Correct Answers: $_correctAnswers, Total Attempts: $_totalAttempts, Accuracy: ${accuracy.toStringAsFixed(2)}%';
  }
}
