import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            color: Colors.deepPurple,
            child: Text(
              "Welcome to Quiz App!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Grid of cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 4 / 3,
                children: [
                  HoverCard(
                    child: Card(
                      color: Color(0xFFE1BEE7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, size: 40, color: Colors.purple),
                            SizedBox(height: 10),
                            Text("About the App",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            SizedBox(height: 5),
                            Text(
                              "This is a Flutter quiz app where you can test your knowledge.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  HoverCard(
                    child: Card(
                      color: Color(0xFFBBDEFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group, size: 40, color: Colors.blue),
                            SizedBox(height: 10),
                            Text("Team Members",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            SizedBox(height: 5),
                            Text(
                              "Summiya Ali, Zobia Asad",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  HoverCard(
                    child: Card(
                      color: Colors.purple[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contact_mail, size: 40, color: Colors.purpleAccent),
                            SizedBox(height: 10),
                            Text("Contact Us",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            SizedBox(height: 5),
                            Text(
                              "ssc.summiya.201201@gmail.com",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  HoverCard(
                    child: Card(
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lightbulb, size: 40, color: Colors.blueAccent),
                            SizedBox(height: 10),
                            Text("Why Use Us?",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            SizedBox(height: 5),
                            Text(
                              "Interactive, fun, and effective learning!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer with button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Colors.deepPurple[200],
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/quizHome'); // Changed this line
                  },
                  child: Text("Go to Quizzes", style: GoogleFonts.poppins(fontSize: 18)),
                ),
                SizedBox(height: 10),
                Text(
                  "© 2025 Quiz App",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;

  const HoverCard({Key? key, required this.child}) : super(key: key);

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: _hovering ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        curve: Curves.easeInOut,
        child: Material(
          elevation: _hovering ? 10 : 4,
          borderRadius: BorderRadius.circular(12),
          child: widget.child,
        ),
      ),
    );
  }
}