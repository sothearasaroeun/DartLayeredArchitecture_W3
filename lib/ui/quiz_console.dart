import 'dart:io';

import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;

  QuizConsole({required this.quiz});

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

      // Check for null input
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
  
    print('$name, your score in percentage: $score % correct');
    print('$name, your score in point: $totalScore');
    quiz.showAllScores();
    
    }
    print('--- Quiz Finished ---');
  }
}
 