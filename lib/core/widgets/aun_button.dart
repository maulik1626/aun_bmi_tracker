import 'package:flutter/material.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';

/// A premium reusable button for AUN BMI Tracker.
///
/// Supports elevated (default), outlined, text, and gradient variants.
/// Elevated uses a subtle gradient. All variants feature refined radii
/// and restrained shadows for a high-end feel.
class AunButton extends StatelessWidget {
  const AunButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AunButtonVariant.elevated,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.height,
    this.borderRadius,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final AunButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppDimensions.buttonHeight;
    final effectiveRadius = borderRadius ?? AppDimensions.buttonBorderRadius;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final loadingWidget = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: foregroundColor ??
            (variant == AunButtonVariant.elevated
                ? Colors.white
                : theme.colorScheme.primary),
      ),
    );

    final content = isLoading ? loadingWidget : _buildContent(context);

    Widget button;

    switch (variant) {
      case AunButtonVariant.elevated:
        // Premium gradient elevated button
        button = Container(
          height: effectiveHeight,
          constraints: const BoxConstraints(
            minWidth: AppDimensions.buttonMinWidth,
          ),
          decoration: BoxDecoration(
            gradient: onPressed != null && !isLoading
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      backgroundColor ?? AppColors.primary,
                      backgroundColor?.withValues(alpha: 0.85) ??
                          AppColors.primaryLight.withValues(alpha: 0.9),
                    ],
                  )
                : null,
            color: onPressed == null || isLoading
                ? AppColors.disabled.withValues(alpha: 0.3)
                : null,
            borderRadius: BorderRadius.circular(effectiveRadius),
            boxShadow: onPressed != null && !isLoading
                ? [
                    BoxShadow(
                      color: (backgroundColor ?? AppColors.primary)
                          .withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(effectiveRadius),
              splashColor: Colors.white.withValues(alpha: 0.1),
              highlightColor: Colors.white.withValues(alpha: 0.05),
              child: Center(
                child: DefaultTextStyle(
                  style: (textStyle ??
                          theme.textTheme.titleSmall ??
                          const TextStyle())
                      .copyWith(
                    color: foregroundColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: foregroundColor ?? Colors.white,
                      size: 20,
                    ),
                    child: content,
                  ),
                ),
              ),
            ),
          ),
        );
        break;

      case AunButtonVariant.outlined:
        final effectiveBorderColor =
            borderColor ?? theme.colorScheme.primary.withValues(alpha: 0.5);
        button = SizedBox(
          height: effectiveHeight,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize:
                  Size(AppDimensions.buttonMinWidth, effectiveHeight),
              foregroundColor:
                  foregroundColor ?? theme.colorScheme.primary,
              textStyle: (textStyle ?? theme.textTheme.titleSmall)?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              side: BorderSide(color: effectiveBorderColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
              ),
              backgroundColor: isDark
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : AppColors.primary.withValues(alpha: 0.04),
            ),
            child: content,
          ),
        );
        break;

      case AunButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize:
                Size(AppDimensions.buttonMinWidth, effectiveHeight),
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            textStyle: (textStyle ?? theme.textTheme.titleSmall)?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
            ),
          ),
          child: content,
        );
        break;
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildContent(BuildContext context) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}

/// Visual variants for [AunButton].
enum AunButtonVariant {
  elevated,
  outlined,
  text,
}
