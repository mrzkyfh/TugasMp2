import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/quiz_progress_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../data/quiz_data.dart';
import '../data/quiz_level_model.dart';
import 'quiz_screen.dart';

class LevelSelectionScreen extends ConsumerWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseLevels = QuizData.getLevels();
    final progressAsync = ref.watch(quizLevelProgressProvider);

    return progressAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (starsMap) {
        // Merge saved stars into levels and unlock next level
        final levels = _mergeLevels(baseLevels, starsMap);
        final totalStars =
            starsMap.values.fold(0, (sum, s) => sum + s);
        final maxStars = levels.length * 3;
        final completedCount =
            starsMap.values.where((s) => s > 0).length;
        final overallProgress =
            levels.isEmpty ? 0.0 : completedCount / levels.length;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FF),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.primaryBlue),
              onPressed: () {
                if (Navigator.of(context).canPop()) context.pop();
              },
            ),
            title: Text(
              'Pelajaran Bahasa Inggris',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppTheme.textMain,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // ── Progress header ──────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progres Kamu',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Level ${completedCount + 1}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: overallProgress,
                          backgroundColor: AppTheme.borderGray,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryBlue),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$totalStars / $maxStars ⭐',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              color: AppTheme.textLight,
                            ),
                          ),
                          Text(
                            '${(overallProgress * 100).toInt()}% Selesai',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Levels grid ──────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        return _buildLevelCard(
                            context, levels[index], index + 1);
                      },
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

  // Merge base levels with saved stars from Supabase
  List<QuizLevel> _mergeLevels(
      List<QuizLevel> base, Map<int, int> starsMap) {
    return base.map((level) {
      final savedStars = starsMap[level.id] ?? 0;
      // Level 1 always unlocked; others unlock if previous level completed
      final prevCompleted = level.id == 1 ||
          (starsMap[level.id - 1] ?? 0) > 0;
      return level.copyWith(
        stars: savedStars,
        isLocked: !prevCompleted,
      );
    }).toList();
  }

  Widget _buildLevelCard(
      BuildContext context, QuizLevel level, int levelNumber) {
    final isUnlocked = !level.isLocked;
    final hasStars = level.stars > 0;

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(level: level),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? Colors.white
              : Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? AppTheme.primaryBlue.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppTheme.primaryBlue
                      : Colors.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$levelNumber',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                level.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? AppTheme.textMain : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  level.description,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: isUnlocked ? AppTheme.textLight : Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (hasStars) ...[
                    ...List.generate(3, (i) {
                      return Icon(
                        i < level.stars
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: AppTheme.secondaryYellow,
                        size: 18,
                      );
                    }),
                  ] else if (isUnlocked) ...[
                    const Icon(Icons.play_circle_outline,
                        color: AppTheme.primaryBlue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Mulai',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.lock, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Terkunci',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
