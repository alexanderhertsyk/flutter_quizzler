import 'package:flutter/material.dart';

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
  final List<String> _questions = [
    'You can lead a cow down stairs but not up stairs.',
    'Approximately one quarter of human bones are in the feet.',
    'A slug\'s blood is green.',
  ];
  final List<bool> _answers = [false, true, true];
  final List<Icon> _results = [];
  int _currentQuestionIndex = 0;

  bool get quizFinished => _results.length == _questions.length;
  bool get anyQuestions => _currentQuestionIndex < _questions.length - 1;

  void answerTapped(bool answer) {
    if (quizFinished) return;

    checkAnswer(answer);

    if (anyQuestions) showNextQuestion();
  }

  void showNextQuestion() => setState(() => _currentQuestionIndex++);

  bool answerIsValid(bool answer) => _answers[_currentQuestionIndex] == answer;

  void checkAnswer(bool answer) => setState(() => _results
      .add(answerIsValid(answer) ? validResultIcon() : invalidResultIcon()));

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
                _questions[_currentQuestionIndex],
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
              onPressed: () => answerTapped(true),
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
              onPressed: () => answerTapped(false),
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
