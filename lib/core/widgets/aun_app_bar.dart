import 'package:flutter/material.dart';

import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';

/// A reusable Material 3 app bar for AUN BMI Tracker.
///
/// Wraps [AppBar] with consistent styling and optional convenience features
/// like a back button, action icons, and a bottom widget.
class AunAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AunAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
    this.titleWidget,
  });

  /// Title text displayed in the app bar.
  final String title;

  /// Whether to show a back/close button. Defaults to false.
  final bool showBackButton;

  /// Custom callback for the back button. If null, uses `Navigator.pop`.
  final VoidCallback? onBackPressed;

  /// Action widgets displayed on the right side.
  final List<Widget>? actions;

  /// Custom leading widget. Overrides [showBackButton].
  final Widget? leading;

  /// Whether to center the title. Defaults to true.
  final bool centerTitle;

  /// Override the background color.
  final Color? backgroundColor;

  /// Override the foreground (text/icon) color.
  final Color? foregroundColor;

  /// Override the elevation.
  final double? elevation;

  /// Optional bottom widget (e.g., TabBar).
  final PreferredSizeWidget? bottom;

  /// Optional custom title widget (overrides [title] text).
  final Widget? titleWidget;

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && showBackButton) {
      effectiveLeading = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return AppBar(
      title: titleWidget ?? Text(title),
      centerTitle: centerTitle,
      leading: effectiveLeading,
      automaticallyImplyLeading: !showBackButton && leading == null,
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? AppDimensions.appBarElevation,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
    );
  }

  // ──────────────────────────── Convenience constructors ────────

  /// Creates an app bar with a single action icon button.
  factory AunAppBar.withAction({
    Key? key,
    required String title,
    required IconData actionIcon,
    required VoidCallback onActionPressed,
    String? actionTooltip,
    bool showBackButton = false,
  }) {
    return AunAppBar(
      key: key,
      title: title,
      showBackButton: showBackButton,
      actions: [
        IconButton(
          icon: Icon(actionIcon),
          onPressed: onActionPressed,
          tooltip: actionTooltip,
        ),
      ],
    );
  }

  /// Creates an app bar with a search icon that triggers a callback.
  factory AunAppBar.withSearch({
    Key? key,
    required String title,
    required VoidCallback onSearchPressed,
    bool showBackButton = false,
  }) {
    return AunAppBar.withAction(
      key: key,
      title: title,
      actionIcon: Icons.search,
      onActionPressed: onSearchPressed,
      actionTooltip: 'Search',
      showBackButton: showBackButton,
    );
  }
}
