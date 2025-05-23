import 'package:flutter/material.dart';

class QuizDetailsScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;

  const QuizDetailsScreen({
    Key? key,
    required this.quizId,
    required this.quizTitle,
  }) : super(key: key);

  @override
  _QuizDetailsScreenState createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  int currentQuestionIndex = 0;
  Map<int, String> selectedAnswers = {};

  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'Madrid', 'Paris', 'Lisbon'],
      'answer': 'Paris'
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 'Mars'
    },
    {
      'question': 'What is the largest mammal?',
      'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
      'answer': 'Blue Whale'
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': ['Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen'],
      'answer': 'William Shakespeare'
    },
    {
      'question': 'What is the boiling point of water?',
      'options': ['90°C', '100°C', '80°C', '120°C'],
      'answer': '100°C'
    },
  ];

  void submitQuiz() {
    if (selectedAnswers.length < questions.length) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Text('Incomplete Quiz', style: TextStyle(color: Colors.deepPurple)),
          content: Text(
            'Please answer all questions before submitting.',
            style: TextStyle(color: Colors.deepPurple),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
      );
      return;
    }

    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['answer']) {
        score++;
      }
    }

    Navigator.pushNamed(
      context,
      '/score',
      arguments: {
        'score': score,
        'total': questions.length,
        'quizTitle': widget.quizTitle,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (selectedAnswers.length / questions.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        title: Text(
          widget.quizTitle,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.only(top: kToolbarHeight + 40, left: 16, right: 16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${index + 1}. ${questions[index]['question']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 10),
                            ...List.generate(questions[index]['options'].length, (optIndex) {
                              String option = questions[index]['options'][optIndex];
                              return ListTile(
                                title: Text(
                                  option,
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                leading: Radio<String>(
                                  value: option,
                                  groupValue: selectedAnswers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[index] = value!;
                                    });
                                  },
                                  activeColor: Colors.deepPurple,
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Submit Quiz",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}