import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class Question{
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int score;

  Question({String? id, required this.title, required this.choices, required this.goodChoice, required this.score}) : id = id ?? _uuid.v4();

  factory Question.fromJson(Map<String, dynamic> j) {
    return Question(
      id: j['id'] as String?,
      title: j['title'] as String,
      choices: List<String>.from(j['choices'] as List),
      goodChoice: j['goodChoice'] as String,
      score: j['score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'choices': choices,
      'goodChoice': goodChoice,
      'score': score,
    };
  }
}

class Answer{
  final String id;
  final Question question;
  final String answerChoice;

  Answer({String? id, required this.question, required this.answerChoice}) : id = id ?? _uuid.v4();

  bool isGood(){
    return this.answerChoice == question.goodChoice;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': question.id,
      'answerChoice': answerChoice,
    };
  }

  factory Answer.fromJson(Map<String, dynamic> j, Quiz quiz) {
    final qid = j['questionId'] as String;
    final q = quiz.getQuestionById(qid);
    if (q == null) {
      throw Exception('Question id $qid not found while parsing Answer');
    }
    return Answer(
      id: j['id'] as String?,
      question: q,
      answerChoice: j['answerChoice'] as String,
    );
  }
}

class Player{
  final String id;
  final String name;

  Player({String? id, required this.name}) : id = id ?? _uuid.v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Player.fromJson(Map<String, dynamic> j) {
    return Player(id: j['id'] as String?, name: j['name'] as String);
  }
}

class Submission {
  final String id;
  final Player player;
  final List<Answer> answers;

  Submission({String? id, required this.player, List<Answer>? answers})
      : id = id ?? _uuid.v4(),
        answers = answers ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player': player.toJson(),
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  factory Submission.fromJson(Map<String, dynamic> j, Quiz quiz) {
    final player = Player.fromJson(j['player'] as Map<String, dynamic>);
    final answersJson = (j['answers'] as List).cast<Map<String, dynamic>>();
    final answers = answersJson.map((a) => Answer.fromJson(a, quiz)).toList();
    return Submission(id: j['id'] as String?, player: player, answers: answers);
  }
}

class Quiz{
  final String id;
  final List<Question> questions;
  final List <Answer> answers =[];
  final List<Submission> submissions = [];
  final Map<String, int> players = {};

  Quiz({String? id, required this.questions}) : id = id ?? _uuid.v4();

  Question? getQuestionById(String qid) {
    try {
      return questions.firstWhere((q) => q.id == qid);
    } catch (e) {
      return null;
    }
  }

  Answer? getAnswerById(String aid) {
    try {
      return answers.firstWhere((a) => a.id == aid);
    } catch (_) {
      for (var s in submissions) {
        try {
          return s.answers.firstWhere((a) => a.id == aid);
        } catch (_) {}
      }
      return null;
    }
  }

  void addAnswer(Answer asnwer) {
     this.answers.add(asnwer);
  }

  void resetAnswers() {
    answers.clear();
  }

  void addSubmission(Submission submission) {
    var index = submissions.indexWhere((s) => s.player.name == submission.player.name);
    if (index != -1) {
      submissions[index] = submission;
    } else {
      submissions.add(submission);
    }

    var total = getTotalScoreForAnswers(submission.answers);
    players[submission.player.name] = total;
  }

  int getScoreInPercentageForAnswers(List<Answer> answersToScore) {
    if (questions.isEmpty) return 0;
    int correctCount = 0;
    for (var a in answersToScore) {
      if (a.isGood()) correctCount++;
    }
    return ((correctCount / questions.length) * 100).toInt();
  }

  int getTotalScoreForAnswers(List<Answer> answersToScore) {
    int total = 0;
    for (var a in answersToScore) {
      if (a.isGood()) {
        total += a.question.score;
      }
    }
    return total;
  }

  int getScoreInPercentage() => getScoreInPercentageForAnswers(answers);
  int getTotalScore() => getTotalScoreForAnswers(answers);

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

  factory Quiz.fromJson(Map<String, dynamic> j) {
    var questionsJson = (j['questions'] as List).cast<Map<String, dynamic>>();
    var questions = questionsJson.map((q) => Question.fromJson(q)).toList();
    var quiz = Quiz(id: j['id'] as String?, questions: questions);

    if (j.containsKey('submissions')) {
      var subsJson = (j['submissions'] as List).cast<Map<String, dynamic>>();
      quiz.submissions.addAll(subsJson.map((s) => Submission.fromJson(s, quiz)));
      // update players map from submissions
      for (var sub in quiz.submissions) {
        quiz.players[sub.player.name] = quiz.getTotalScoreForAnswers(sub.answers);
      }
    }

    return quiz;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questions': questions.map((q) => q.toJson()).toList(),
      'submissions': submissions.map((s) => s.toJson()).toList(),
    };
  }
}
