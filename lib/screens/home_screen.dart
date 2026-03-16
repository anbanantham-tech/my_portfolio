import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            // Additional sections will be added here
            Container(
              height: 500,
              color: const Color(0xFF1E293B),
              child: const Center(
                child: Text(
                  'More sections coming soon...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
