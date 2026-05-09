import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';
import 'user_progress_provider.dart';

// Vocabulary list provider
final vocabularyProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  return await SupabaseService.getUserVocabulary(user.id);
});

// Vocabulary controller using Notifier
class VocabularyController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> addWord({
    required String userId,
    required String word,
    required String translation,
    required String pronunciation,
    required String definition,
    String? level,
  }) async {
    state = const AsyncValue.loading();
    try {
      await SupabaseService.addToVocabulary({
        'user_id': userId,
        'word': word,
        'translation': translation,
        'pronunciation': pronunciation,
        'definition': definition,
        'level': level ?? 'beginner',
        'mastery': 0.0,
        'created_at': DateTime.now().toIso8601String(),
      });
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateMastery({
    required String wordId,
    required double mastery,
  }) async {
    state = const AsyncValue.loading();
    try {
      await SupabaseService.updateWord(wordId, {'mastery': mastery});
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final vocabularyControllerProvider =
    NotifierProvider<VocabularyController, AsyncValue<void>>(() {
  return VocabularyController();
});
