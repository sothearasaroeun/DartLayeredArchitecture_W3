import 'dart:convert';
import 'dart:io';
import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;

  QuizRepository(this.filePath);

  Quiz readQuiz() {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('Quiz file not found: $filePath');
    }

    final jsonString = file.readAsStringSync();
    final jsonData = jsonDecode(jsonString);
    return Quiz.fromJson(jsonData);
  }

  // Bonus: write a Quiz into the JSON file synchronously
  void writeQuiz(Quiz quiz) {
    final file = File(filePath);
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(quiz.toJson());

    file.writeAsStringSync(prettyJson);
  }
}