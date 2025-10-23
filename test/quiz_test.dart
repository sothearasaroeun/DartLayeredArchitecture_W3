import 'package:my_first_project/domain/quiz.dart';
import 'package:test/test.dart';

void main() {
  Question q1 =
      Question(title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", score: 50);
  Question q2 =
      Question(title: "4+2", choices: ["2", "4", "6"], goodChoice: "6", score: 50);

  late Quiz quiz;

  setUp(() {
    quiz = Quiz(questions: [q1, q2]);
    quiz.resetAnswers();
    quiz.submissions.clear();
    quiz.answers.clear();
  });

  test("test 1 (All answer are right)", () {
    Player player1 = Player(name: "Ronan");
    quiz.addAnswer(Answer(question: q1, answerChoice: "2"));
    quiz.addAnswer(Answer(question: q2, answerChoice: "6"));

    // SCore should be 100%
    expect(quiz.getScoreInPercentage(), equals(100));
    expect(quiz.getTotalScore(), equals(100));

    print("${player1.name} score: ${quiz.getTotalScore()} points "
          "(${quiz.getScoreInPercentage()}%)");

  });

  test("test 2 (All Answer are wrong)", () {
    Player player2 = Player(name: "Sotheara");
    quiz.addAnswer(Answer(question: q1, answerChoice: "7"));
    quiz.addAnswer(Answer(question: q2, answerChoice: "9"));

    expect(quiz.getScoreInPercentage(), equals(0));
    expect(quiz.getTotalScore(), equals(0));

    print("${player2.name} score: ${quiz.getTotalScore()} points "
          "(${quiz.getScoreInPercentage()}%)");

  });

  test("submission saved and overwritten", () {
    final player = Player(name: 'Sam');
    final sub1Answers = [
      Answer(question: q1, answerChoice: "2"),
      Answer(question: q2, answerChoice: "4"),
    ];
    quiz.addSubmission(Submission(player: player, answers: sub1Answers));
    expect(quiz.submissions.length, equals(1));
    expect(quiz.players['Sam'], equals(50));

    final sub2Answers = [
      Answer(question: q1, answerChoice: "1"),
      Answer(question: q2, answerChoice: "6"),
    ];
    quiz.addSubmission(Submission(player: player, answers: sub2Answers));
    expect(quiz.submissions.length, equals(1)); 
    expect(quiz.players['Sam'], equals(50));
  });
}