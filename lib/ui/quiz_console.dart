import 'dart:io';
import '../data/quiz_file_provider.dart';
import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;
  final QuizFileProvider? fileProvider;

  QuizConsole({required this.quiz, this.fileProvider});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');

    while(true){
      stdout.write('Enter your name: ');
      String? name = stdin.readLineSync();

      if (name == null || name.trim().isEmpty){
        break;
      }

      Player player = Player(name: name.trim());
      quiz.resetAnswers();

    for (var question in quiz.questions) {
      print('Question: ${question.title}');
      print('Choices: ${question.choices}');
      stdout.write('Your answer: ');
      String? userInput = stdin.readLineSync();

      if (userInput != null && userInput.isNotEmpty) {
        Answer answer = Answer(question: question, answerChoice: userInput);
        quiz.addAnswer(answer);
      } else {
        print('No answer entered. Skipping question.');
      }
      print('');
    }

    int score = quiz.getScoreInPercentage();
    int totalScore  = quiz.getTotalScore();
    quiz.addOrUpdatePlayer(player.name, totalScore);
  
    final submission = Submission(player: player, answers: List.from(quiz.answers));
    quiz.addSubmission(submission);

    print('$name, your score in percentage: $score % correct');
    print('$name, your score in point: $totalScore');
    quiz.showAllScores();
    
    if (fileProvider != null) {
        fileProvider!.saveQuiz(quiz);
      }
    }
    print('--- Quiz Finished ---');
  }
}