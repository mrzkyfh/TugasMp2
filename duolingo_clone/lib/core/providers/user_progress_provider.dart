import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_progress_model.dart';
import '../services/supabase_service.dart';

// ─── Raw current user provider ───────────────────────────────────────────────
final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

// ─── User progress provider (fetch + realtime) ───────────────────────────────
final userProgressProvider =
    StreamProvider<UserProgressModel>((ref) async* {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    yield UserProgressModel.empty('');
    return;
  }

  // Initial fetch
  final initial = await SupabaseService.getUserProgress(user.id);
  if (initial != null) {
    yield UserProgressModel.fromMap(initial);
  } else {
    // First time: create a fresh row
    await SupabaseService.updateUserProgress(
      user.id,
      UserProgressModel.empty(user.id).toMap(),
    );
    yield UserProgressModel.empty(user.id);
  }

  // Realtime updates
  await for (final rows in Supabase.instance.client
      .from('user_progress')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)) {
    if (rows.isNotEmpty) {
      yield UserProgressModel.fromMap(rows.first);
    }
  }
});

// ─── User progress controller ─────────────────────────────────────────────────
class UserProgressController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> addXp(int amount) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = const AsyncValue.loading();
    try {
      final current = await SupabaseService.getUserProgress(user.id);
      final progress = current != null
          ? UserProgressModel.fromMap(current)
          : UserProgressModel.empty(user.id);

      final now = DateTime.now();
      final lastActivity = progress.lastActivityDate;
      final isNewDay = lastActivity == null ||
          now.difference(lastActivity).inDays >= 1;

      // Reset daily XP if new day
      final newDailyXp = isNewDay ? amount : progress.currentDailyXp + amount;

      // Level up every 1000 XP
      final newTotalXp = progress.xp + amount;
      final newLevel = (newTotalXp / 1000).floor() + 1;

      // Update streak
      final newStreak = isNewDay ? progress.streakDays + 1 : progress.streakDays;

      await SupabaseService.updateUserProgress(user.id, {
        'xp': newTotalXp,
        'level': newLevel,
        'current_daily_xp': newDailyXp,
        'streak_days': newStreak,
        'last_activity_date': now.toIso8601String(),
      });

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> incrementWordsLearned() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      final current = await SupabaseService.getUserProgress(user.id);
      final progress = current != null
          ? UserProgressModel.fromMap(current)
          : UserProgressModel.empty(user.id);

      await SupabaseService.updateUserProgress(user.id, {
        'total_words_learned': progress.totalWordsLearned + 1,
      });
    } catch (_) {}
  }

  Future<void> resetDailyXp() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      await SupabaseService.updateUserProgress(user.id, {
        'current_daily_xp': 0,
        'last_activity_date': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }
}

final userProgressControllerProvider =
    NotifierProvider<UserProgressController, AsyncValue<void>>(
  UserProgressController.new,
);
