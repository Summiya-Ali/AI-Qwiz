import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'score_display.dart'; // <- Make sure this exists and is correct

class QuizDetailsScreen extends StatefulWidget {
  final String quizTitle;
  final List<Map<String, dynamic>> questions;

  const QuizDetailsScreen({
    Key? key,
    required this.quizTitle,
    required this.questions,
  }) : super(key: key);

  @override
  _QuizDetailsScreenState createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  int _currentIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  bool _quizFinished = false;

  void _submitQuiz() {
    int score = _calculateScore();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreDisplayScreen(
          score: score,
          total: widget.questions.length,
          quizTitle: widget.quizTitle,
          questions: widget.questions,              // ✅ now passed
          selectedAnswers: _selectedAnswers,
        ),
      ),
    );
  }


  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_selectedAnswers[i] == widget.questions[i]['answer']) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz Error')),
        body: Center(child: Text('No questions were generated.')),
      );
    }

    final currentQuestion = widget.questions[_currentIndex];
    final options = List<String>.from(currentQuestion['options']);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.lightBlue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
              SizedBox(height: 20),

              // Question Text
              Text(
                'Question ${_currentIndex + 1}/${widget.questions.length}',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[800]),
              ),
              SizedBox(height: 10),
              Text(
                currentQuestion['question'],
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              // Options
              ...options.map((option) {
                bool isSelected = _selectedAnswers[_currentIndex] == option;
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: RadioListTile<String>(
                    title: Text(option, style: GoogleFonts.poppins(fontSize: 16)),
                    value: option,
                    groupValue: _selectedAnswers[_currentIndex],
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswers[_currentIndex] = value!;
                      });
                    },
                  ),
                );
              }).toList(),

              Spacer(),

              // Navigation Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_currentIndex < widget.questions.length - 1) {
                    setState(() {
                      _currentIndex++;
                    });
                  } else {
                    _submitQuiz();
                  }
                },
                child: Text(
                  _currentIndex < widget.questions.length - 1 ? 'Next Question' : 'Submit Quiz',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
              SizedBox(height: 12),

              // Chat Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.deepPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                child: Text(
                  "Take help from AI",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
