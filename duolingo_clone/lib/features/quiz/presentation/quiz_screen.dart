import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fluenta/core/theme/app_theme.dart';
import 'package:fluenta/core/providers/user_progress_provider.dart';
import 'package:fluenta/core/providers/quiz_progress_provider.dart';
import 'package:fluenta/core/services/supabase_service.dart';
import 'package:fluenta/shared/widgets/primary_button.dart';
import 'package:fluenta/shared/widgets/option_card.dart';
import '../data/quiz_level_model.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final QuizLevel level;

  const QuizScreen({super.key, required this.level});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with SingleTickerProviderStateMixin {
  static const int _maxLives = 5;

  int _currentQuestionIndex = 0;
  int? _selectedIndex;
  bool _isAnswerChecked = false;
  bool _isAnswerCorrect = false;
  int _correctAnswers = 0;
  int _lives = _maxLives;
  bool _isGameOver = false;

  late AnimationController _heartShakeController;
  late Animation<double> _heartShakeAnimation;

  QuizQuestion get _currentQuestion =>
      widget.level.questions[_currentQuestionIndex];
  double get _progress =>
      (_currentQuestionIndex + 1) / widget.level.questions.length;

  @override
  void initState() {
    super.initState();
    _heartShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _heartShakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
          parent: _heartShakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _heartShakeController.dispose();
    super.dispose();
  }

  void _onCheckAnswer() {
    if (_selectedIndex == null || _isGameOver) return;

    if (!_isAnswerChecked) {
      final isCorrect =
          _selectedIndex == _currentQuestion.correctAnswerIndex;
      setState(() {
        _isAnswerChecked = true;
        _isAnswerCorrect = isCorrect;
        if (isCorrect) {
          _correctAnswers++;
        } else {
          _lives--;
          _heartShakeController.forward(from: 0);
        }
      });

      // If lives run out, show game over after a short delay
      if (_lives <= 0) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _showGameOver();
        });
      }
    } else {
      // Advance to next question or finish
      if (_currentQuestionIndex < widget.level.questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _isAnswerChecked = false;
          _selectedIndex = null;
          _isAnswerCorrect = false;
        });
      } else {
        _finishQuiz();
      }
    }
  }

  // ── Calculate stars ──────────────────────────────────────────────────────────
  int _calculateStars() {
    final percentage =
        (_correctAnswers / widget.level.questions.length) * 100;
    if (percentage >= 90) return 3;
    if (percentage >= 70) return 2;
    if (percentage >= 50) return 1;
    return 0;
  }

  // ── Save progress to Supabase ────────────────────────────────────────────────
  Future<void> _saveProgress(int stars) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final xp = xpForStars(stars);

    // Save level stars
    await SupabaseService.saveQuizLevelProgress(
      userId: user.id,
      levelId: widget.level.id,
      stars: stars,
    );

    // Add XP to user progress
    if (xp > 0) {
      await ref.read(userProgressControllerProvider.notifier).addXp(xp);
    }

    // Save quiz result
    await SupabaseService.saveQuizResult({
      'user_id': user.id,
      'level_id': widget.level.id,
      'score': ((_correctAnswers / widget.level.questions.length) * 100).toInt(),
      'total_questions': widget.level.questions.length,
      'correct_answers': _correctAnswers,
      'stars': stars,
      'xp_earned': xp,
    });

    // Invalidate quiz progress so level selection refreshes
    ref.invalidate(quizLevelProgressProvider);
  }

  // ── Finish quiz ──────────────────────────────────────────────────────────────
  void _finishQuiz() {
    final stars = _calculateStars();
    _saveProgress(stars);
    _showQuizResults(stars);
  }

  // ── Game Over dialog ─────────────────────────────────────────────────────────
  void _showGameOver() {
    if (!mounted) return;
    setState(() => _isGameOver = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            const Icon(Icons.heart_broken, color: AppTheme.dangerRed, size: 56),
            const SizedBox(height: 12),
            Text(
              'Nyawa Habis!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
          ],
        ),
        content: Text(
          'Kamu kehabisan nyawa. Coba lagi dari awal!',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 15,
            color: AppTheme.textLight,
            height: 1.5,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Restart quiz
                    setState(() {
                      _currentQuestionIndex = 0;
                      _selectedIndex = null;
                      _isAnswerChecked = false;
                      _isAnswerCorrect = false;
                      _correctAnswers = 0;
                      _lives = _maxLives;
                      _isGameOver = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (Navigator.of(context).canPop()) context.pop();
                },
                child: Text(
                  'Keluar',
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: AppTheme.textLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Results dialog ───────────────────────────────────────────────────────────
  void _showQuizResults(int stars) {
    if (!mounted) return;
    final percentage =
        (_correctAnswers / widget.level.questions.length) * 100;
    final xp = xpForStars(stars);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300 + i * 150),
                  child: Icon(
                    i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                    key: ValueKey('$i-$stars'),
                    color: AppTheme.secondaryYellow,
                    size: 48,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Text(
              stars == 3
                  ? '🎉 Sempurna!'
                  : stars == 2
                      ? '👏 Bagus Sekali!'
                      : stars == 1
                          ? '💪 Usaha Bagus!'
                          : '😅 Coba Lagi!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Score
            Text(
              '$_correctAnswers / ${widget.level.questions.length}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            Text(
              '${percentage.toInt()}% Benar',
              style: GoogleFonts.lexend(
                fontSize: 15,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 16),
            // XP earned
            if (xp > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt,
                        color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '+$xp XP',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            // Lives remaining
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_maxLives, (i) {
                return Icon(
                  i < _lives ? Icons.favorite : Icons.favorite_border,
                  color: AppTheme.dangerRed,
                  size: 22,
                );
              }),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    if (Navigator.of(context).canPop()) context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Lanjutkan',
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _currentQuestionIndex = 0;
                    _selectedIndex = null;
                    _isAnswerChecked = false;
                    _isAnswerCorrect = false;
                    _correctAnswers = 0;
                    _lives = _maxLives;
                    _isGameOver = false;
                  });
                },
                child: Text(
                  'Main Lagi',
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: AppTheme.textLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Difficulty helpers ───────────────────────────────────────────────────────
  Color _getDifficultyColor() {
    switch (_currentQuestion.difficulty) {
      case 'easy':
        return AppTheme.primaryGreen;
      case 'medium':
        return AppTheme.secondaryYellow;
      case 'hard':
        return AppTheme.dangerRed;
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _getDifficultyLabel() {
    switch (_currentQuestion.difficulty) {
      case 'easy':
        return 'MUDAH';
      case 'medium':
        return 'MENENGAH';
      case 'hard':
        return 'SULIT';
      default:
        return 'MUDAH';
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppTheme.textLight, size: 28),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) context.pop();
                    },
                  ),
                  Expanded(
                    child: LinearPercentIndicator(
                      lineHeight: 16.0,
                      percent: _progress,
                      barRadius: const Radius.circular(8),
                      backgroundColor: AppTheme.borderGray,
                      progressColor: AppTheme.primaryGreen,
                      animation: true,
                      animateFromLastPercent: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ── Lives ──────────────────────────────────────────────────
                  AnimatedBuilder(
                    animation: _heartShakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_heartShakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.favorite,
                            color: AppTheme.dangerRed, size: 26),
                        const SizedBox(width: 4),
                        Text(
                          '$_lives',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.dangerRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Question content ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getDifficultyLabel(),
                            style: GoogleFonts.lexend(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Soal ${_currentQuestionIndex + 1} dari ${widget.level.questions.length}',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _currentQuestion.question,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _currentQuestion.options.length,
                        itemBuilder: (context, index) {
                          return OptionCard(
                            text: _currentQuestion.options[index],
                            isSelected: _selectedIndex == index,
                            onTap: _isAnswerChecked
                                ? () {}
                                : () => setState(
                                    () => _selectedIndex = index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom action bar ────────────────────────────────────────────
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    Color bgColor = Colors.white;
    String buttonText = 'PERIKSA';
    Color buttonColor = AppTheme.borderGray;
    Color shadowColor = AppTheme.borderGray;
    Color textColor = AppTheme.textLight;

    if (_selectedIndex != null && !_isAnswerChecked) {
      buttonColor = AppTheme.primaryGreen;
      shadowColor = AppTheme.primaryGreenShadow;
      textColor = Colors.white;
    } else if (_isAnswerChecked) {
      buttonText =
          _currentQuestionIndex < widget.level.questions.length - 1
              ? 'LANJUT'
              : 'SELESAI';
      if (_isAnswerCorrect) {
        bgColor = const Color(0xFFD7FFB8);
        buttonColor = AppTheme.primaryGreen;
        shadowColor = AppTheme.primaryGreenShadow;
        textColor = Colors.white;
      } else {
        bgColor = const Color(0xFFFFD8D8);
        buttonColor = AppTheme.dangerRed;
        shadowColor = const Color(0xFFEA2B2B);
        textColor = Colors.white;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 24.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(
            top: BorderSide(color: AppTheme.borderGray, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isAnswerChecked) ...[
            Row(
              children: [
                Icon(
                  _isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                  color: _isAnswerCorrect
                      ? AppTheme.primaryGreen
                      : AppTheme.dangerRed,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  _isAnswerCorrect ? 'Hebat!' : 'Salah!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _isAnswerCorrect
                            ? AppTheme.primaryGreen
                            : AppTheme.dangerRed,
                      ),
                ),
              ],
            ),
            if (!_isAnswerCorrect) ...[
              const SizedBox(height: 8),
              Text(
                'Jawaban benar: ${_currentQuestion.options[_currentQuestion.correctAnswerIndex]}',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: AppTheme.dangerRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Show remaining lives
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Sisa nyawa: ',
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      color: AppTheme.dangerRed,
                    ),
                  ),
                  ...List.generate(_maxLives, (i) {
                    return Icon(
                      i < _lives
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppTheme.dangerRed,
                      size: 18,
                    );
                  }),
                ],
              ),
            ],
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            text: buttonText,
            color: buttonColor,
            shadowColor: shadowColor,
            textColor: textColor,
            onPressed: _lives > 0 ? _onCheckAnswer : () {},
          ),
        ],
      ),
    );
  }
}
