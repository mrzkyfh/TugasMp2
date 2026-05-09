import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  // Auth methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  // Database methods
  static Future<List<Map<String, dynamic>>> getWords() async {
    final response = await client.from('words').select();
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addWord(Map<String, dynamic> word) async {
    await client.from('words').insert(word);
  }

  static Future<void> updateWord(String id, Map<String, dynamic> updates) async {
    await client.from('words').update(updates).eq('id', id);
  }

  static Future<void> deleteWord(String id) async {
    await client.from('words').delete().eq('id', id);
  }

  // User progress methods
  static Future<Map<String, dynamic>?> getUserProgress(String userId) async {
    final response = await client
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }

  static Future<void> updateUserProgress(
    String userId,
    Map<String, dynamic> progress,
  ) async {
    await client.from('user_progress').upsert({
      'user_id': userId,
      ...progress,
    });
  }

  // Quiz level progress methods
  static Future<List<Map<String, dynamic>>> getQuizLevelProgress(
    String userId,
  ) async {
    final response = await client
        .from('quiz_level_progress')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveQuizLevelProgress({
    required String userId,
    required int levelId,
    required int stars,
  }) async {
    await client.from('quiz_level_progress').upsert({
      'user_id': userId,
      'level_id': levelId,
      'stars': stars,
      'completed': stars > 0,
    }, onConflict: 'user_id,level_id');
  }

  // Quiz methods
  static Future<List<Map<String, dynamic>>> getQuizzes() async {
    final response = await client.from('quizzes').select();
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveQuizResult(Map<String, dynamic> result) async {
    await client.from('quiz_results').insert(result);
  }

  // Vocabulary methods
  static Future<List<Map<String, dynamic>>> getUserVocabulary(
    String userId,
  ) async {
    final response = await client
        .from('user_vocabulary')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addToVocabulary(Map<String, dynamic> vocabulary) async {
    await client.from('user_vocabulary').insert(vocabulary);
  }

  // Chat history methods
  static Future<List<Map<String, dynamic>>> getChatHistory(
    String userId,
  ) async {
    final response = await client
        .from('chat_history')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveChatMessage(Map<String, dynamic> message) async {
    await client.from('chat_history').insert(message);
  }
}
