import 'package:flutter/material.dart';

class ScoreDisplayScreen extends StatefulWidget {
  final int score;
  final int total;
  final String quizTitle;

  const ScoreDisplayScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.quizTitle,
  }) : super(key: key);

  @override
  _ScoreDisplayScreenState createState() => _ScoreDisplayScreenState();
}

class _ScoreDisplayScreenState extends State<ScoreDisplayScreen> {
  int rating = 0;
  final TextEditingController feedbackController = TextEditingController();

  void setRating(int value) {
    setState(() {
      rating = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Your Score"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground Content
          Container(
            padding: EdgeInsets.only(
                top: kToolbarHeight + 24, left: 16, right: 16, bottom: 16),
            child: Center(
              child: Card(
                elevation: 10,
                color: Colors.white.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "🎉 ${widget.quizTitle} Completed!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "You scored",
                          style: TextStyle(fontSize: 18,
                              color: Colors.deepPurple[900]),
                        ),
                        Text(
                          "${widget.score} / ${widget.total}",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Rate this quiz:",
                          style: TextStyle(fontSize: 18,
                              color: Colors.deepPurple[900]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () => setRating(index + 1),
                              icon: Icon(
                                Icons.star,
                                color: rating >= index + 1
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: feedbackController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Your feedback",
                            labelStyle: TextStyle(
                                color: Colors.deepPurple[900]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          style: TextStyle(color: Colors.deepPurple[900]),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            String feedback = feedbackController.text;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Thanks for your feedback!"),
                              ),
                            );
                          },
                          child: Text("Submit Feedback"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
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