import '../domain/quiz.dart';
import 'quiz_repository.dart';

class QuizFileProvider {
  final QuizRepository repository;

  QuizFileProvider(this.repository);

  Quiz loadQuiz() => repository.readQuiz();

  void saveQuiz(Quiz quiz) => repository.writeQuiz(quiz);
}