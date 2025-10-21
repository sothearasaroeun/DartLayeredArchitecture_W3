class Question{
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int score;

  Question({required this.title, required this.choices, required this.goodChoice, required this.score});

}

class Answer{
  final Question question;
  final String answerChoice;

  Answer({required this.question, required this.answerChoice});

  bool isGood(){
    return this.answerChoice == question.goodChoice;
  }
}

class Player{
  final String name;

  Player({required this.name});

  String toString(){
    return name;
  }
}

class Quiz{
  List<Question> questions;
  List <Answer> answers =[];
  Map<String, int> players = {};


  Quiz({required this.questions});

  void addAnswer(Answer asnwer) {
     this.answers.add(asnwer);
  }

  int getScoreInPercentage(){
    int totalSCore =0;
    for(Answer answer in answers){
      if (answer.isGood()) {
        totalSCore++;
      }
    }
    return ((totalSCore/ questions.length)*100).toInt();
  }

  int getTotalScore(){
    int totalScore = 0;
    for(Answer answer in answers){
      if (answer.isGood()) {
        totalScore += answer.question.score;
      }
    }
    return totalScore;
  }

  void addOrUpdatePlayer(String name, int score){
    players[name] = score;
  }

  void showAllScores(){
    print(' ');
    if(players.isEmpty){
      print('No players yet.');
    } else {
      players.forEach((name, score){
        print('Player: $name  Score: $score');
      });
    }
  }

  void resetAnswers(){
    answers.clear();
  }
}
