import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';
import '../widgets/experience_timeline.dart';
import '../widgets/projects_grid.dart';
import '../widgets/contact_form.dart';
import '../widgets/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ResponsiveLayout(
        mobileBody: _buildMobileBody(),
        tabletBody: _buildTabletBody(),
        desktopBody: _buildDesktopBody(),
      ),
    );
  }

  Widget _buildMobileBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: const [
            HeroSection(),
            ExperienceTimeline(),
            ProjectsGrid(),
            ContactForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: const [
            HeroSection(),
            ExperienceTimeline(),
            ProjectsGrid(),
            ContactForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopBody() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              children: const [
                HeroSection(),
                ExperienceTimeline(),
                ProjectsGrid(),
                ContactForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
