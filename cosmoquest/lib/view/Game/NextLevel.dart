import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:flutter/material.dart';

class NextLevelScreen extends StatelessWidget {
  final bool passed;
  final int rating;  // Add rating as a new parameter
  final VoidCallback onNextLevel;
  final VoidCallback onRetry;

  const NextLevelScreen({
    super.key,
    required this.passed,
    required this.rating,  // Initialize rating
    required this.onNextLevel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(passed ? 'Level Complete' : 'Level Failed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              passed ? 'Congratulations! You passed this level!' : "Sorry, you didn\'t pass this level.",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildRatingStars(),
            if (passed)
              Text(
                'Your rating: $rating/3 stars',  // Display the rating when passed
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            Text(
              passed ? 'Get ready for the next level!' : 'You can retry the level to improve your score.',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: passed ? onNextLevel : onRetry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text(passed ? 'Start Next Level' : 'Retry Level'),
            ),
            if (passed)
              const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationBarHome()),
                    (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Return to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index){
        return Icon(Icons.star, color: index < rating ? Colors.yellow : Colors.grey,);
      }),
    );
  }
}
