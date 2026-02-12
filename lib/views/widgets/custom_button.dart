import 'package:flutter/material.dart';

import 'pressable_scale.dart';

enum ButtonVariant { primary, outline, ghost }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = ButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final onTap = isLoading ? null : onPressed;

    Widget button;
    switch (variant) {
      case ButtonVariant.outline:
        button = OutlinedButton(onPressed: onTap, child: child);
      case ButtonVariant.ghost:
        button = TextButton(onPressed: onTap, child: child);
      case ButtonVariant.primary:
        button = ElevatedButton(onPressed: onTap, child: child);
    }

    return PressableScale(child: button);
  }
}
