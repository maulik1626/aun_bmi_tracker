import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';

/// A premium text field for AUN BMI Tracker.
///
/// Minimal design with a thin border that lights up on focus.
/// Dark-mode optimised with subtle fill and refined typography.
class AunTextField extends StatelessWidget {
  const AunTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.fillColor,
    this.contentPadding,
    this.borderRadius,
    this.textAlign = TextAlign.start,
    this.style,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final TextAlign textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? AppDimensions.textFieldBorderRadius;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultFill = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceVariant;
    final borderIdle = isDark ? AppColors.darkOutline : AppColors.lightOutline;

    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      focusNode: focusNode,
      textAlign: textAlign,
      style: style ??
          theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffixText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: AppColors.primary)
            : null,
        suffixIcon: suffixIcon,
        suffixStyle: TextStyle(
          color: isDark
              ? AppColors.darkOnSurfaceSecondary
              : AppColors.lightOnSurfaceSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.darkOnSurfaceTertiary
              : AppColors.lightOnSurfaceTertiary,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: isDark
              ? AppColors.darkOnSurfaceTertiary
              : AppColors.lightOnSurfaceTertiary,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: fillColor ?? defaultFill,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingLg,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveRadius),
          borderSide: BorderSide(color: borderIdle, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveRadius),
          borderSide: BorderSide(color: borderIdle, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ──────────────────────────── Convenience constructors ────────

  /// Creates a numeric text field pre-configured for number input.
  factory AunTextField.numeric({
    Key? key,
    required TextEditingController controller,
    String? label,
    String? hint,
    String? suffixText,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    bool autofocus = false,
    TextAlign textAlign = TextAlign.center,
    TextStyle? style,
  }) {
    return AunTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      suffixText: suffixText,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      focusNode: focusNode,
      autofocus: autofocus,
      textAlign: textAlign,
      style: style,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
    );
  }
}
