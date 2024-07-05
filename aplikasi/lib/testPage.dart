import 'package:flutter/material.dart';
import 'package:aplikasi/databaseHelper.dart';
import 'package:aplikasi/home.dart'; // Assuming this is where HomePage is defined

class Question {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late Question _currentQuestion; // Track current question
  List<Question> _questions = [
    Question(
      questionText: 'Apa ibu kota Indonesia?',
      answers: ['Jakarta', 'Bandung', 'Surabaya', 'Medan'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Siapa presiden pertama Indonesia?',
      answers: ['Sukarno', 'Suharto', 'Habibie', 'Gus Dur'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Berapakah 2 + 2?',
      answers: ['3', '4', '5', '6'],
      correctAnswerIndex: 1,
    ),
    // Add more quiz questions here
  ];

  @override
  void initState() {
    super.initState();
    _currentQuestion = _questions[_currentQuestionIndex];
  }

  void _answerQuestion(int selectedIndex) async {
    if (_currentQuestion.correctAnswerIndex == selectedIndex) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      _currentQuestionIndex++;
      if (_currentQuestionIndex < _questions.length) {
        _currentQuestion = _questions[_currentQuestionIndex];
      }
    });

    if (_currentQuestionIndex >= _questions.length) {
      await _saveScoreToDatabase(_score);
      print('Score saved: $_score');
      _navigateToHomePage();
    }
  }

  Future<void> _saveScoreToDatabase(int score) async {
    final conn = await DatabaseHelper().getConnection();
    await conn.query('INSERT INTO quiz_result (score) VALUES (?)', [score]);
    await conn.close();
  }

  void _navigateToHomePage() {
    print('Navigating to HomePage...');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(), // Ensure HomePage is imported correctly
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 400.0,
            height: 360.0, 
            decoration: BoxDecoration(
              color: Colors.black, // Side color of the card
              borderRadius: BorderRadius.circular(10.0),
            ),// Set the width of the card here
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      _currentQuestion.questionText,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ..._currentQuestion.answers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String answer = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _answerQuestion(idx),
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(answer),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
