import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24.0 : 64.0,
            vertical: isMobile ? 48.0 : 80.0,
          ),
          child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTextContent(isMobile: true),
                const SizedBox(height: 32),
                _buildCTAButtons(isMobile: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextContent(isMobile: false),
                      const SizedBox(height: 32),
                      _buildCTAButtons(isMobile: false),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildIllustration(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContent({required bool isMobile}) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Anbanantham T',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 36 : 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Flutter & Supabase Developer | Cloud & DevOps Enthusiast',
          style: GoogleFonts.roboto(
            fontSize: isMobile ? 18 : 24,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Building seamless cross-platform applications and transitioning into robust cloud infrastructure.',
          style: GoogleFonts.roboto(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.normal,
            color: Colors.white.withValues(alpha: 0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButtons({required bool isMobile}) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        _buildPrimaryButton(isMobile: isMobile),
        _buildSecondaryButton(isMobile: isMobile),
      ],
    );
  }

  Widget _buildPrimaryButton({required bool isMobile}) {
    return ElevatedButton(
      onPressed: _launchResume,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 32,
          vertical: isMobile ? 12 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        'Download Resume',
        style: GoogleFonts.roboto(
          fontSize: isMobile ? 14 : 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({required bool isMobile}) {
    return OutlinedButton(
      onPressed: _launchGitHub,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 2),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 32,
          vertical: isMobile ? 12 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'View GitHub',
        style: GoogleFonts.roboto(
          fontSize: isMobile ? 14 : 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5).withValues(alpha: 0.1),
            const Color(0xFF7C3AED).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.code,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchResume() async {
    // TODO: Replace with actual resume URL
    final Uri resumeUrl = Uri.parse('https://example.com/resume.pdf');
    if (!await launchUrl(resumeUrl)) {
      debugPrint('Could not launch resume URL');
    }
  }

  Future<void> _launchGitHub() async {
    final Uri githubUrl = Uri.parse('https://github.com/anbanantham-tech');
    if (!await launchUrl(githubUrl)) {
      debugPrint('Could not launch GitHub URL');
    }
  }
}
