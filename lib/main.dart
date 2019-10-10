import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  int questionNumber = 0;
  int rightAnswers = 0;
  int wrongAnswers = 0;
  QuizBrain quizBrain = QuizBrain();
  int questionsLenght;

  void checkQuestion(bool userAnswer) {
    if (questionNumber < quizBrain.getQuestionsLenght()) {
      if (userAnswer == quizBrain.getQuestionAnswer(questionNumber)) {
        rightAnswers++;
        scoreKeeper.add(
          Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
      } else {
        wrongAnswers++;
        scoreKeeper.add(
          Icon(
            Icons.close,
            color: Colors.red,
          ),
        );
      }
      setState(() {
        questionNumber++;
      });
    }
  }

  _onAlertWithStylePressed(context) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: rightAnswers >= wrongAnswers
            ? TextStyle(color: Color.fromRGBO(114, 224, 128, 1.0), fontSize: 24)
            : TextStyle(color: Colors.red, fontSize: 24),
        descStyle: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w400,
        ));

    questionsLenght = quizBrain.getQuestionsLenght();

    Alert(
      context: context,
      style: alertStyle,
      type: rightAnswers >= wrongAnswers ? AlertType.success : AlertType.error,
      title: rightAnswers >= wrongAnswers ? "QUIZ PASSED!" : "QUIZ FAILED!",
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Right Answers',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(114, 224, 128, 1.0),
                  ),
                ),
                Text(
                  '$rightAnswers/$questionsLenght',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(114, 224, 128, 1.0),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Wrong Answers',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  '$wrongAnswers/$questionsLenght',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      desc: "This quiz has ended. Check your stats:",
      buttons: [
        DialogButton(
          child: Text(
            "RESTART",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            _restartApp();
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Colors.greenAccent,
            Colors.redAccent,
          ]),
          radius: BorderRadius.circular(4.0),
        ),
      ],
    ).show();
  }

  _restartApp() {
    setState(() {
      scoreKeeper = [];
      questionNumber = 0;
      rightAnswers = 0;
      wrongAnswers = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                questionNumber < quizBrain.getQuestionsLenght()
                    ? quizBrain.getQuestionText(questionNumber)
                    : quizBrain.getQuestionText(questionNumber - 1),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        questionNumber < quizBrain.getQuestionsLenght() - 1
            ? Expanded(
                flex: 1,
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
                      //The user picked true.
                      checkQuestion(true);
                    },
                  ),
                ),
              )
            : new Container(),
        questionNumber < quizBrain.getQuestionsLenght() - 1
            ? Expanded(
                flex: 1,
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
                      //The user picked false.
                      checkQuestion(false);
                    },
                  ),
                ),
              )
            : Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text(
                      'Finish Quiz!',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _onAlertWithStylePressed(context);
                    },
                  ),
                ),
              ),
        Container(
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
