import 'dart:io';
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';
import 'data/quiz_repository.dart';
import 'data/quiz_file_provider.dart';

// void main() {

//   List<Question> questions = [
//     Question(
//         title: "Capital of France?",
//         choices: ["Paris", "London", "Rome"],
//         goodChoice: "Paris",
//         score: 10),
//     Question(
//         title: "2 + 2 = ?", 
//         choices: ["2", "4", "5"], 
//         goodChoice: "4",
//         score: 50),
//   ];

//   Quiz quiz = Quiz(questions: questions);
//   QuizConsole console = QuizConsole(quiz: quiz);

//   console.startQuiz();
// }

void main() {
  final repo = QuizRepository('assets/quiz_data.json');
  Quiz quiz;

  try {
    quiz = repo.readQuiz();
  } catch (e) {
    print('Error reading quiz: $e');
    return;
  }

  final fileProvider = QuizFileProvider(repo);

  final console = QuizConsole(quiz: quiz, fileProvider: fileProvider);

  console.startQuiz();

}