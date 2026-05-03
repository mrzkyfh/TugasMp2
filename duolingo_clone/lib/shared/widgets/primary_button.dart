import 'package:flutter/material.dart';
import 'package:fluenta/core/theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final bool isOutline;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppTheme.primaryBlue,
    this.shadowColor = AppTheme.primaryBlueShadow,
    this.textColor = Colors.white,
    this.isOutline = false,
  });

  const PrimaryButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.shadowColor = AppTheme.borderGray,
    this.textColor = AppTheme.primaryBlue,
    this.isOutline = true,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 4.0 : 0.0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          border: widget.isOutline
              ? Border.all(color: widget.shadowColor, width: 2)
              : null,
          boxShadow: widget.isOutline
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: Offset(0, _isPressed ? 0 : 4),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              widget.text.toUpperCase(),
              style: TextStyle(
                color: widget.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
