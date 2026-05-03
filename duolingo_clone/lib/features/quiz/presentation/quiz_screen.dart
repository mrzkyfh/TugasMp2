import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:go_router/go_router.dart';

import 'package:fluenta/core/theme/app_theme.dart';
import 'package:fluenta/shared/widgets/primary_button.dart';
import 'package:fluenta/shared/widgets/option_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedIndex;
  bool _isAnswerChecked = false;
  bool _isAnswerCorrect = false;
  double _progress = 0.2;

  final List<String> _options = ['El niño', 'La niña', 'El hombre', 'La mujer'];

  final int _correctAnswerIndex = 1; // "La niña" is correct

  void _onCheckAnswer() {
    if (_selectedIndex == null) return;

    if (!_isAnswerChecked) {
      // Check answer
      setState(() {
        _isAnswerChecked = true;
        _isAnswerCorrect = _selectedIndex == _correctAnswerIndex;
      });
    } else {
      // Continue to next question
      if (_isAnswerCorrect) {
        setState(() {
          _progress += 0.2; // Increase progress
        });
      }

      if (_progress >= 1.0) {
        // Finish quiz
        context.pop();
        return;
      }

      setState(() {
        _isAnswerChecked = false;
        _selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR: Close, Progress, Hearts
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppTheme.textLight,
                      size: 28,
                    ),
                    onPressed: () => context.pop(),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: AppTheme.dangerRed,
                        size: 28,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '5',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.dangerRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // QUIZ CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Translate this sentence',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    // Prompt
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mascot Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppTheme.borderGray,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.pets,
                            size: 40,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Speech Bubble
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.borderGray,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'The girl',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Options Grid/List
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
                        itemCount: _options.length,
                        itemBuilder: (context, index) {
                          return OptionCard(
                            text: _options[index],
                            isSelected: _selectedIndex == index,
                            onTap: _isAnswerChecked
                                ? () {}
                                : () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM ACTION BAR
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    Color bgColor = Colors.white;
    String buttonText = 'CHECK';
    Color buttonColor = AppTheme.borderGray;
    Color shadowColor = AppTheme.borderGray;
    Color textColor = AppTheme.textLight;

    if (_selectedIndex != null && !_isAnswerChecked) {
      buttonColor = AppTheme.primaryGreen;
      shadowColor = AppTheme.primaryGreenShadow;
      textColor = Colors.white;
    } else if (_isAnswerChecked) {
      buttonText = 'CONTINUE';
      if (_isAnswerCorrect) {
        bgColor = const Color(0xFFD7FFB8); // Light Green
        buttonColor = AppTheme.primaryGreen;
        shadowColor = AppTheme.primaryGreenShadow;
        textColor = Colors.white;
      } else {
        bgColor = const Color(0xFFFFD8D8); // Light Red
        buttonColor = AppTheme.dangerRed;
        shadowColor = const Color(0xFFEA2B2B);
        textColor = Colors.white;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: AppTheme.borderGray, width: 2)),
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
                  _isAnswerCorrect ? 'Excellent!' : 'Correct solution:',
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
                _options[_correctAnswerIndex],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.dangerRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            text: buttonText,
            color: buttonColor,
            shadowColor: shadowColor,
            textColor: textColor,
            onPressed: _onCheckAnswer,
          ),
        ],
      ),
    );
  }
}
