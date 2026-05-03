import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDF4FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.secondaryBlue : AppTheme.borderGray,
            width: 2,
          ),
          boxShadow: isSelected
              ? []
              : [
                  const BoxShadow(
                    color: AppTheme.borderGray,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppTheme.secondaryBlue : AppTheme.textMain,
            ),
          ),
        ),
      ),
    );
  }
}
