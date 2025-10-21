import 'package:my_first_project/domain/quiz.dart';
import 'package:test/test.dart';

void main() {
  Question q1 =
      Question(title: "4-2", choices: ["1", "2", "3"], goodChoice: "2", score: 50);
  Question q2 =
      Question(title: "4+2", choices: ["1", "2", "3"], goodChoice: "6", score: 50);

  Quiz quiz = Quiz(questions: [q1, q2]);

  setUp(() {
    quiz.answers.clear();
  });

  test("test 1", () {
    Player player1 = Player(name: "Ronan");
    List<Answer> answers = [];
    answers.add(Answer(question: q1, answerChoice: "2"));
    answers.add(Answer(question: q2, answerChoice: "6"));
    quiz.answers = answers;

    // SCore should be 100%
    expect(quiz.getScoreInPercentage(), equals(100));
    expect(quiz.getTotalScore(), equals(100));

    print("${player1.name} score: ${quiz.getTotalScore()} points "
          "(${quiz.getScoreInPercentage()}%)");

  });

  test("test 2 (All Answer are wrong)", () {
    Player player2 = Player(name: "Sotheara");
    List<Answer> answers = [];
    answers.add(Answer(question: q1, answerChoice: "7"));
    answers.add(Answer(question: q2, answerChoice: "9"));
    quiz.answers = answers;

    print("asnwer size = ${quiz.answers.length}");

    // SCore should be 100%
    expect(quiz.getScoreInPercentage(), equals(0));
    expect(quiz.getTotalScore(), equals(0));

    print("${player2.name} score: ${quiz.getTotalScore()} points "
          "(${quiz.getScoreInPercentage()}%)");

  });
}