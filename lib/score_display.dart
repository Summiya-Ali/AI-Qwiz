import 'package:flutter/material.dart';
import 'quiz_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ScoreDisplayScreen extends StatefulWidget {
  final int score;
  final int total;
  final String quizTitle;
  final List<Map<String, dynamic>> questions;
  final Map<int, String> selectedAnswers;

  const ScoreDisplayScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.quizTitle,
    required this.questions,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  _ScoreDisplayScreenState createState() => _ScoreDisplayScreenState();
}

class _ScoreDisplayScreenState extends State<ScoreDisplayScreen> {
  int rating = 0;
  final TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saveResultToFirebase();
  }

  void _saveResultToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child('quiz_results').child(user.uid).push().set({
      'quizTitle': widget.quizTitle,
      'score': widget.score,
      'total': widget.total,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void setRating(int value) {
    setState(() {
      rating = value;
    });
  }

  void _retakeQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizDetailsScreen(
          quizTitle: widget.quizTitle,
          questions: widget.questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Your Score"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Gradient overlay
          ),
          Container(
            padding: EdgeInsets.only(
              top: kToolbarHeight + 24,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Card(
                  elevation: 12,
                  color: Colors.white.withOpacity(0.96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "🎉 ${widget.quizTitle} Completed!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[800],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "You scored",
                          style: TextStyle(fontSize: 18),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Text(
                            "${widget.score} / ${widget.total}",
                            key: ValueKey(widget.score),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _retakeQuiz,
                          icon: Icon(Icons.refresh),
                          label: Text("Retake Quiz"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Review Answers",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(widget.questions.length, (index) {
                          final question = widget.questions[index];
                          final correctAnswer = question['answer'];
                          final selectedAnswer = widget.selectedAnswers[index];
                          final isCorrect = selectedAnswer == correctAnswer;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: isCorrect
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            child: ListTile(
                              leading: Icon(
                                isCorrect ? Icons.check_circle : Icons.close,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                              title: Text(
                                question['question'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Your Answer: $selectedAnswer",
                                    style: TextStyle(
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                  if (!isCorrect)
                                    Text(
                                      "Correct Answer: $correctAnswer",
                                      style:
                                      TextStyle(color: Colors.green[800]),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 30),
                        const Text(
                          "Rate this quiz:",
                          style:
                          TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () => setRating(index + 1),
                              icon: Icon(
                                Icons.star,
                                size: 28,
                                color: rating >= index + 1
                                    ? Colors.amber
                                    : Colors.grey[400],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: feedbackController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Your feedback",
                            labelStyle: TextStyle(
                                color: Colors.deepPurple[800],
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          style:
                          TextStyle(color: Colors.deepPurple[900]),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Thanks for your feedback!"),
                              ),
                            );
                          },
                          icon: Icon(Icons.send),
                          label: Text("Submit Feedback"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
