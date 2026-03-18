import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/supabase_service.dart';

class ProjectsGrid extends StatefulWidget {
  const ProjectsGrid({super.key});

  @override
  State<ProjectsGrid> createState() => _ProjectsGridState();
}

class _ProjectsGridState extends State<ProjectsGrid> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Map<String, dynamic>>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _supabaseService.fetchProjects();
  }

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
              _buildProjectsContent(isMobile: isMobile),
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
                  'Featured Projects',
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

  Widget _buildProjectsContent({required bool isMobile}) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF4F46E5)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load projects',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        }

        final projects = snapshot.data ?? [];

        if (projects.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.folder_open,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No projects found.',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return _buildProjectsGrid(projects, isMobile: isMobile);
      },
    );
  }

  Widget _buildProjectsGrid(List<Map<String, dynamic>> projects, {required bool isMobile}) {
    if (isMobile) {
      return Column(
        children: projects.asMap().entries.map((entry) {
          final index = entry.key;
          final project = entry.value;
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _ProjectCard(
                      project: _mapProjectData(project),
                      isMobile: isMobile,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.2,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _ProjectCard(
                    project: _mapProjectData(project),
                    isMobile: isMobile,
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  _ProjectData _mapProjectData(Map<String, dynamic> project) {
    // Default values for icon and color based on project index or type
    IconData icon;
    Color color;
    
    // You can customize this logic based on your database schema
    if (project['title']?.toString().toLowerCase().contains('app') == true) {
      icon = Icons.phone_android;
      color = const Color(0xFF4F46E5);
    } else if (project['title']?.toString().toLowerCase().contains('web') == true ||
               project['title']?.toString().toLowerCase().contains('system') == true) {
      icon = Icons.dashboard;
      color = const Color(0xFF7C3AED);
    } else {
      icon = Icons.code;
      color = const Color(0xFF4F46E5);
    }

    // Parse technologies if they're stored as a string or list
    List<String> technologies = [];
    if (project['technologies'] != null) {
      if (project['technologies'] is List) {
        technologies = List<String>.from(project['technologies']);
      } else if (project['technologies'] is String) {
        technologies = (project['technologies'] as String).split(',').map((t) => t.trim()).toList();
      }
    }

    return _ProjectData(
      title: project['title']?.toString() ?? 'Untitled Project',
      description: project['description']?.toString() ?? 'No description available.',
      technologies: technologies.isEmpty ? ['Technology'] : technologies,
      icon: icon,
      color: color,
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  final bool isMobile;

  const _ProjectCard({
    required this.project,
    required this.isMobile,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          // Navigate to project details - implement navigation logic here
          // Examples:
          // Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailsPage(project: widget.project)));
          // Or use a named route: Navigator.pushNamed(context, '/project-details', arguments: widget.project);
          debugPrint('Navigate to project: ${widget.project.title}');
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0)
            ..scaleByDouble(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF1E293B),
            border: Border.all(
              color: widget.project.color.withValues(alpha: _isHovered ? 0.5 : 0.2),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.project.color.withValues(alpha: _isHovered ? 0.3 : 0.1),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 12 : 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.isMobile ? 20 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                const SizedBox(height: 16),
                _buildTitle(),
                const SizedBox(height: 12),
                _buildDescription(),
                const Spacer(),
                _buildTechnologies(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: widget.isMobile ? 48 : 56,
      height: widget.isMobile ? 48 : 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.project.color,
            widget.project.color.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.project.color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        widget.project.icon,
        color: Colors.white,
        size: widget.isMobile ? 24 : 28,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.project.title,
      style: GoogleFonts.poppins(
        fontSize: widget.isMobile ? 18 : 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.project.description,
      style: GoogleFonts.roboto(
        fontSize: widget.isMobile ? 14 : 16,
        fontWeight: FontWeight.normal,
        color: Colors.white.withValues(alpha: 0.8),
        height: 1.5,
      ),
    );
  }

  Widget _buildTechnologies() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.project.technologies.map((tech) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 8 : 12,
            vertical: widget.isMobile ? 4 : 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.project.color.withValues(alpha: 0.1),
            border: Border.all(
              color: widget.project.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            tech,
            style: GoogleFonts.roboto(
              fontSize: widget.isMobile ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: widget.project.color.withValues(alpha: 0.9),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ProjectData {
  final String title;
  final String description;
  final List<String> technologies;
  final IconData icon;
  final Color color;

  _ProjectData({
    required this.title,
    required this.description,
    required this.technologies,
    required this.icon,
    required this.color,
  });
}
