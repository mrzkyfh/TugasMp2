import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';
import 'user_progress_provider.dart';

// Map of levelId -> stars (0-3)
final quizLevelProgressProvider =
    FutureProvider<Map<int, int>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};

  final rows = await SupabaseService.getQuizLevelProgress(user.id);
  return {
    for (final row in rows)
      (row['level_id'] as int): (row['stars'] as int? ?? 0),
  };
});

// XP earned per star count
int xpForStars(int stars) {
  switch (stars) {
    case 1:
      return 50;
    case 2:
      return 100;
    case 3:
      return 150;
    default:
      return 0;
  }
}
