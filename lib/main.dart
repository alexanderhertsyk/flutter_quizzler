import 'package:flutter/material.dart';
import 'package:flutter_quizzler/quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
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
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String _questionText = quizBrain.question;
  final List<Icon> _results = [];

  Future<void> reviewUserResponse(bool answer, BuildContext context) async {
    if (quizBrain.completed) {
      var repeat = await showAlertDialog(context, 'Do you want to repeat?');

      if (repeat) {
        resetQuiz();
      }
    } else {
      checkAnswer(answer);
    }
  }

  void checkAnswer(bool answer) {
    var valid = quizBrain.validateAnswer(answer);
    setResult(valid);
    setNextQuestion();
  }

  void setNextQuestion() => setState(() {
        quizBrain.moveToTheNextQuestion();
        _questionText = quizBrain.question;
      });

  void setResult(bool valid) => setState(
      () => _results.add(valid ? validResultIcon() : invalidResultIcon()));

  void resetQuiz() => setState(() {
        _results.clear();
        quizBrain.resetQuiz();
      });

  Icon validResultIcon() => const Icon(Icons.check, color: Colors.green);
  Icon invalidResultIcon() => const Icon(Icons.close, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                _questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () async => await reviewUserResponse(true, context),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () async => await reviewUserResponse(false, context),
            ),
          ),
        ),
        Row(
          children: _results,
        )
      ],
    );
  }
}

Future<bool> showAlertDialog(BuildContext context, String message,
    {String confirm = 'Yes', String decline = 'No'}) async {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text(decline),
    onPressed: () {
      // returnValue = false;
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text(confirm),
    onPressed: () {
      // returnValue = true;
      Navigator.of(context).pop(true);
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  final result = await showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return result ?? false;
}
