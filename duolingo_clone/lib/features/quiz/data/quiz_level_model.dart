class QuizLevel {
  final int id;
  final String title;
  final String description;
  final int totalQuestions;
  final String category;
  final List<QuizQuestion> questions;
  final bool isLocked;
  final int stars; // 0-3 stars
  final double progress; // 0.0 to 1.0

  QuizLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.category,
    required this.questions,
    this.isLocked = true,
    this.stars = 0,
    this.progress = 0.0,
  });

  QuizLevel copyWith({int? stars, bool? isLocked, double? progress}) {
    return QuizLevel(
      id: id,
      title: title,
      description: description,
      totalQuestions: totalQuestions,
      category: category,
      questions: questions,
      isLocked: isLocked ?? this.isLocked,
      stars: stars ?? this.stars,
      progress: progress ?? this.progress,
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String difficulty; // 'easy', 'medium', 'hard'

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.difficulty = 'medium',
  });
}

class QuizProgress {
  final int currentLevel;
  final int totalLevels;
  final int totalStars;
  final int maxStars;
  final double overallProgress;

  QuizProgress({
    required this.currentLevel,
    required this.totalLevels,
    required this.totalStars,
    required this.maxStars,
    required this.overallProgress,
  });
}
