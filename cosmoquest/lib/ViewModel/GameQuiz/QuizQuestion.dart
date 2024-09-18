// class QuizQuestion {
//   final String question;
//   final List<String> options;
//   final String correctAnswer;
//
//   QuizQuestion({
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });
// }

// Sample questions for the Astrology NASA quiz
import 'package:cosmoquest/Model/QuizQuestion.dart';

final List<QuizQuestion> astrologyNASAQuestions = [
  QuizQuestion(
    question: 'What is the largest planet in our solar system?',
    options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
    correctAnswer: 'Jupiter',
  ),
  QuizQuestion(
    question: 'Which planet is known as the Red Planet?',
    options: ['Mars', 'Saturn', 'Neptune', 'Mercury'],
    correctAnswer: 'Mars',
  ),
  QuizQuestion(
    question: 'How many moons does Earth have?',
    options: ['1', '2', '3', '4'],
    correctAnswer: '1',
  ),
  QuizQuestion(
    question: 'What is the name of NASA’s most famous space telescope?',
    options: ['Voyager', 'Hubble', 'Cassini', 'Chandra'],
    correctAnswer: 'Hubble',
  ),
  QuizQuestion(
    question: 'Which planet has the most moons?',
    options: ['Saturn', 'Jupiter', 'Uranus', 'Neptune'],
    correctAnswer: 'Jupiter',
  ),
  QuizQuestion(
    question: 'What galaxy is the Earth located in?',
    options: ['Andromeda', 'Milky Way', 'Whirlpool', 'Triangulum'],
    correctAnswer: 'Milky Way',
  ),
  QuizQuestion(
    question: 'Which planet is closest to the Sun?',
    options: ['Earth', 'Venus', 'Mercury', 'Mars'],
    correctAnswer: 'Mercury',
  ),
  QuizQuestion(
    question: 'Which planet is known for its beautiful rings?',
    options: ['Jupiter', 'Saturn', 'Uranus', 'Neptune'],
    correctAnswer: 'Saturn',
  ),
  QuizQuestion(
    question: 'What is the smallest planet in our solar system?',
    options: ['Mercury', 'Venus', 'Earth', 'Mars'],
    correctAnswer: 'Mercury',
  ),
  QuizQuestion(
    question: 'What is the name of NASA’s rover on Mars?',
    options: ['Curiosity', 'Opportunity', 'Spirit', 'Perseverance'],
    correctAnswer: 'Perseverance',
  ),
];
