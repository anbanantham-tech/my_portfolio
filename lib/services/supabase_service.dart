import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetches all projects from the database ordered by display_order
  Future<List<Map<String, dynamic>>> fetchProjects() async {
    try {
      final response = await _supabase
          .from('projects')
          .select('*')
          .order('display_order', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch projects: $e');
    }
  }

  /// Submits a new contact form message to the messages table
  Future<void> submitContactForm(String name, String email, String message) async {
    try {
      await _supabase.from('messages').insert({
        'sender_name': name,
        'sender_email': email,
        'message_body': message,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to submit contact form: $e');
    }
  }
}
