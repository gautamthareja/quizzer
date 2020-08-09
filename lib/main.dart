import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int totalQuestion = quizBrain.totalQuestions();
  int correct = 0;
  int wrong = 0;

  void checkAnswer(bool userAnswer) {
    bool answer = quizBrain.getQuestionAnswer();
    setState(() {
      if (quizBrain.quizEnded() == true) {
        Alert(
          context: context,
          buttons: [
            DialogButton(
              child: Text(
                "Restart Quiz",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  quizBrain.restartQuiz();
                  scoreKeeper.clear();
                  correct = 0;
                  wrong = 0;
                });
              },
              width: 220,
            )
          ],
          title: "Quiz Finished",
          desc: "Your score is $correct out of $totalQuestion.",
        ).show();
      } else if (answer == userAnswer && quizBrain.quizEnded() == false) {
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
        correct++;
        quizBrain.nextQuestion();
      } else if (answer != userAnswer && quizBrain.quizEnded() == false) {
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
        wrong++;
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizBrain.quizEnded() == true) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    quizBrain.restartQuiz();
                    scoreKeeper.clear();
                    correct = 0;
                    wrong = 0;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      '...QUIZ FINISHED...\n'
                      'Correct Responses: $correct\n'
                      'Incoorect Responses: $wrong\n\n\n'
                      'Tap anywhere to retake Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (quizBrain.quizEnded() == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  quizBrain.getQuestionText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  //user presses true
                  if (quizBrain.quizEnded() == false) checkAnswer(true);
                  if (quizBrain.quizEnded() == true) checkAnswer(true);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                color: Colors.red,
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //user presses false
                  if (quizBrain.quizEnded() == false) checkAnswer(false);
                  if (quizBrain.quizEnded() == true) checkAnswer(true);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: scoreKeeper,
          ),
        ],
      );
    }
  }
}
