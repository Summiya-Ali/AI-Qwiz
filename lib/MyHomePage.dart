import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'firebase_service.dart'; // Keep this if you use it, otherwise remove.
import 'package:url_launcher/url_launcher.dart'; // For opening links like email, LinkedIn

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key}); // Added const constructor

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // Added AnimationController for a subtle header animation
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  // New: AnimationController for the main button pulse effect
  late AnimationController _buttonPulseController;
  late Animation<double> _buttonScaleAnimation;


  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    )..forward(); // Start the animation forward when screen loads

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic, // A smoother, more natural curve
    );

    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Quick pulse duration
    )..repeat(reverse: true); // Repeat indefinitely, reversing direction

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _buttonPulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _headerController.dispose(); // Dispose header controller
    _buttonPulseController.dispose(); // Dispose button pulse controller
    super.dispose();
  }

  // Function to launch URLs (email, LinkedIn)
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    // Determine crossAxisCount for GridView based on screen width
    int crossAxisCount = (screenSize.width > 900) ? 3 : (screenSize.width > 600 ? 2 : 1);
    // Adjusted aspect ratio for better icon presentation
    double cardAspectRatio = (screenSize.width > 900) ? 1.4 : (screenSize.width > 600 ? 1.3 : 1.1);

    return Scaffold(
      // Use theme background color for better light/dark mode support
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // Background Gradient
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backk.jpg'), // <-- Your background image path
                  fit: BoxFit.cover, // Makes it stretch and cover the entire background
                ),
              ),
            ),
          ),

          // Main content column
          SafeArea(
            child: Column(
              children: [
                // Animated Header (Welcome Message)
                FadeTransition(
                  opacity: _headerAnimation,
                  child: ScaleTransition(
                    scale: _headerAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to Quiz App!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: screenSize.width * 0.07 > 36 ? 36 : screenSize.width * 0.07,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Challenge your knowledge and learn new things!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: screenSize.width * 0.035 > 18 ? 18 : screenSize.width * 0.035,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Grid of Enhanced Cards (Adaptive)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: cardAspectRatio,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return _buildInfoCard(
                              context,
                              icon: Icons.info_outline,
                              iconColor: Colors.deepPurple, // Matching primary color
                              iconBackgroundColor: Colors.deepPurple.shade50,
                              title: "About the App",
                              description: "This is a Flutter quiz app where you can test your knowledge.",
                              cardColor: Theme.of(context).cardColor,
                            );
                          case 1:
                            return _buildInfoCard(
                              context,
                              icon: Icons.group,
                              iconColor: Colors.blueAccent,
                              iconBackgroundColor: Colors.blue.shade50,
                              title: "Team Members",
                              description: "Summiya Ali, Zobia Asad",
                              cardColor: Theme.of(context).cardColor,
                            );
                          case 2:
                            return _buildInfoCard(
                              context,
                              icon: Icons.mail_outline, // Changed icon
                              iconColor: Colors.green,
                              iconBackgroundColor: Colors.green.shade50,
                              title: "Contact Us",
                              description: "ssc.summiya.201201@gmail.com",
                              cardColor: Theme.of(context).cardColor,
                              onTap: () => _launchUrl('mailto:ssc.summiya.201201@gmail.com?subject=Quiz App Inquiry'),
                            );
                          case 3:
                            return _buildInfoCard(
                              context,
                              icon: Icons.lightbulb_outline, // Changed icon
                              iconColor: Colors.orange,
                              iconBackgroundColor: Colors.orange.shade50,
                              title: "Why Use Us?",
                              description: "Interactive, fun, and effective learning!",
                              cardColor: Theme.of(context).cardColor,
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),

                // Footer with enhanced button and copyright
                ScaleTransition(
                  scale: _headerAnimation, // Animate the footer too
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                    child: Column(
                      children: [
                        ScaleTransition( // New: Apply pulse animation to button
                          scale: _buttonScaleAnimation,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Contact Links
                        Wrap(
                          spacing: 15,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _launchUrl('mailto:contact@quizapp.com?subject=Inquiry'),
                              child: Text(
                                "Email Us",
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _launchUrl('tel:+1234567890'),
                              child: Text(
                                "Call Us",
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _launchUrl('https://linkedin.com/in/quizapp'), // Dummy LinkedIn
                              child: Text(
                                "LinkedIn",
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "© 2025 Quiz App",
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent info cards
  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon, // Changed to IconData
        required Color iconColor,
        required Color iconBackgroundColor, // New: for icon's background circle
        required String title,
        required String description,
        required Color cardColor,
        VoidCallback? onTap, // New: optional onTap callback for the card
      }) {
    return HoverCard(
      // Use InkWell for the card itself to enable tap feedback
      child: InkWell(
        onTap: onTap, // Assign the optional onTap
        borderRadius: BorderRadius.circular(18),
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon within a colored circle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor, // Light background for icon
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 40, color: iconColor), // Icon itself
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusing your existing HoverCard widget, but with slight Material elevation adjustments
class HoverCard extends StatefulWidget {
  final Widget child;

  const HoverCard({Key? key, required this.child}) : super(key: key);

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _hovering ? Matrix4.translationValues(0, -8, 0) : Matrix4.identity(),
        curve: Curves.easeInOutBack,
        child: Material(
          elevation: _hovering ? 12 : 5,
          borderRadius: BorderRadius.circular(18),
          shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(_hovering ? 0.6 : 0.2),
          child: widget.child,
        ),
      ),
    );
  }
}
