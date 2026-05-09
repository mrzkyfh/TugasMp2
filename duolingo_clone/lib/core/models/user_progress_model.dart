class UserProgressModel {
  final String id;
  final String userId;
  final int level;
  final int xp;
  final int streakDays;
  final int totalWordsLearned;
  final int dailyGoalXp;
  final int currentDailyXp;
  final DateTime? lastActivityDate;

  const UserProgressModel({
    required this.id,
    required this.userId,
    required this.level,
    required this.xp,
    required this.streakDays,
    required this.totalWordsLearned,
    required this.dailyGoalXp,
    required this.currentDailyXp,
    this.lastActivityDate,
  });

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    return UserProgressModel(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      level: (map['level'] as num?)?.toInt() ?? 1,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      streakDays: (map['streak_days'] as num?)?.toInt() ?? 0,
      totalWordsLearned: (map['total_words_learned'] as num?)?.toInt() ?? 0,
      dailyGoalXp: (map['daily_goal_xp'] as num?)?.toInt() ?? 1000,
      currentDailyXp: (map['current_daily_xp'] as num?)?.toInt() ?? 0,
      lastActivityDate: map['last_activity_date'] != null
          ? DateTime.tryParse(map['last_activity_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'level': level,
      'xp': xp,
      'streak_days': streakDays,
      'total_words_learned': totalWordsLearned,
      'daily_goal_xp': dailyGoalXp,
      'current_daily_xp': currentDailyXp,
      'last_activity_date': lastActivityDate?.toIso8601String(),
    };
  }

  // Computed properties
  double get dailyGoalProgress =>
      dailyGoalXp > 0 ? (currentDailyXp / dailyGoalXp).clamp(0.0, 1.0) : 0.0;

  String get levelLabel {
    if (level <= 3) return 'Pemula';
    if (level <= 6) return 'Dasar';
    if (level <= 10) return 'Menengah';
    if (level <= 15) return 'Menengah Atas';
    if (level <= 20) return 'Mahir';
    return 'Pakar';
  }

  bool get isGoalReached => currentDailyXp >= dailyGoalXp;

  String get dailyGoalMessage {
    if (isGoalReached) return '🎉 Target harian tercapai! Luar biasa!';
    final remaining = dailyGoalXp - currentDailyXp;
    if (remaining <= 100) return 'Hampir sampai! Tinggal $remaining XP lagi!';
    return 'Terus semangat! Sisa $remaining XP untuk mencapai targetmu.';
  }

  UserProgressModel copyWith({
    int? level,
    int? xp,
    int? streakDays,
    int? totalWordsLearned,
    int? dailyGoalXp,
    int? currentDailyXp,
    DateTime? lastActivityDate,
  }) {
    return UserProgressModel(
      id: id,
      userId: userId,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      dailyGoalXp: dailyGoalXp ?? this.dailyGoalXp,
      currentDailyXp: currentDailyXp ?? this.currentDailyXp,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }

  static UserProgressModel empty(String userId) => UserProgressModel(
        id: '',
        userId: userId,
        level: 1,
        xp: 0,
        streakDays: 0,
        totalWordsLearned: 0,
        dailyGoalXp: 1000,
        currentDailyXp: 0,
      );
}
