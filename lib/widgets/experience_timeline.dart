import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(isMobile: isMobile),
              const SizedBox(height: 48),
              _buildTimeline(isMobile: isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle({required bool isMobile}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Experience & Education',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 28 : 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeline({required bool isMobile}) {
    final experiences = [
      _ExperienceData(
        title: 'Application Development Intern',
        company: 'Featherwork Technologies',
        period: 'July 2025 - Jan 2026',
        type: _ExperienceType.work,
        bulletPoints: [
          'Built cross-platform mobile apps with Flutter and integrated Supabase for secure backend authentication and PostgreSQL queries.',
        ],
        icon: Icons.work,
      ),
      _ExperienceData(
        title: 'Digital Marketing and WordPress Developer',
        company: 'Noxlay Cyber Tech',
        period: 'June 2024 - May 2025',
        type: _ExperienceType.work,
        bulletPoints: [
          'Developed responsive WordPress sites and executed onsite SEO, using Google Lighthouse for performance auditing.',
        ],
        icon: Icons.web,
      ),
      _ExperienceData(
        title: 'Bachelor of Computer Applications (BCA)',
        company: 'Sri Kaliswari College',
        period: '2021 - 2024',
        type: _ExperienceType.education,
        bulletPoints: [
          'Focused on software development, database management, and web technologies.',
        ],
        icon: Icons.school,
      ),
    ];

    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;
        final isLast = index == experiences.length - 1;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + (index * 200)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _TimelineItem(
                  experience: experience,
                  isMobile: isMobile,
                  isLast: isLast,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final _ExperienceData experience;
  final bool isMobile;
  final bool isLast;

  const _TimelineItem({
    required this.experience,
    required this.isMobile,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineDot(),
          const SizedBox(width: 24),
          Expanded(
            child: _buildExperienceCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineDot() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: experience.type == _ExperienceType.work
                  ? [const Color(0xFF4F46E5), const Color(0xFF6366F1)]
                  : [const Color(0xFF7C3AED), const Color(0xFFA855F7)],
            ),
            boxShadow: [
              BoxShadow(
                color: experience.type == _ExperienceType.work
                    ? const Color(0xFF4F46E5).withValues(alpha: 0.3)
                    : const Color(0xFF7C3AED).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            experience.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4F46E5).withValues(alpha: 0.3),
                    const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExperienceCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E293B),
        border: Border.all(
          color: const Color(0xFF334155).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildPeriod(),
          const SizedBox(height: 16),
          _buildBulletPoints(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience.title,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          experience.company,
          style: GoogleFonts.roboto(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w500,
            color: experience.type == _ExperienceType.work
                ? const Color(0xFF6366F1)
                : const Color(0xFFA855F7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriod() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: experience.type == _ExperienceType.work
            ? const Color(0xFF4F46E5).withValues(alpha: 0.1)
            : const Color(0xFF7C3AED).withValues(alpha: 0.1),
        border: Border.all(
          color: experience.type == _ExperienceType.work
              ? const Color(0xFF4F46E5).withValues(alpha: 0.3)
              : const Color(0xFF7C3AED).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        experience.period,
        style: GoogleFonts.roboto(
          fontSize: isMobile ? 12 : 14,
          fontWeight: FontWeight.w500,
          color: experience.type == _ExperienceType.work
              ? const Color(0xFF818CF8)
              : const Color(0xFFC084FC),
        ),
      ),
    );
  }

  Widget _buildBulletPoints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: experience.bulletPoints.map((bullet) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6, right: 12),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: experience.type == _ExperienceType.work
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFA855F7),
                ),
              ),
              Expanded(
                child: Text(
                  bullet,
                  style: GoogleFonts.roboto(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

enum _ExperienceType { work, education }

class _ExperienceData {
  final String title;
  final String company;
  final String period;
  final _ExperienceType type;
  final List<String> bulletPoints;
  final IconData icon;

  _ExperienceData({
    required this.title,
    required this.company,
    required this.period,
    required this.type,
    required this.bulletPoints,
    required this.icon,
  });
}
