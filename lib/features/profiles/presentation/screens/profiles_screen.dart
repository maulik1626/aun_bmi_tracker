import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aun_bmi_tracker/core/constants/app_colors.dart';
import 'package:aun_bmi_tracker/core/constants/app_dimensions.dart';
import 'package:aun_bmi_tracker/core/constants/app_strings.dart';
import 'package:aun_bmi_tracker/features/profiles/data/models/profile_model.dart';
import 'package:aun_bmi_tracker/features/profiles/presentation/providers/profile_provider.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(profilesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Header ----
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.screenPaddingH,
                right: AppDimensions.screenPaddingH,
                top: AppDimensions.spacingXl,
                bottom: AppDimensions.spacingLg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.profilesTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  // Add button - elegant inline
                  _AddButton(
                    isDark: isDark,
                    onTap: () => _showProfileSheet(context, ref, isDark),
                  ),
                ],
              ),
            ),

            // ---- Profile list ----
            Expanded(
              child: profilesAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (profiles) {
                  if (profiles.isEmpty) {
                    return _EmptyState(
                      isDark: isDark,
                      onAdd: () =>
                          _showProfileSheet(context, ref, isDark),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingH,
                    ),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimensions.spacingMd),
                        child: _ProfileCard(
                          profile: profile,
                          isDark: isDark,
                          onEdit: () => _showProfileSheet(
                            context,
                            ref,
                            isDark,
                            existing: profile,
                          ),
                          onDelete: () {
                            if (profile.id != null) {
                              ref
                                  .read(profilesProvider.notifier)
                                  .deleteProfile(profile.id!);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add button - minimal
// ---------------------------------------------------------------------------

class _AddButton extends StatelessWidget {
  const _AddButton({required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark, required this.onAdd});

  final bool isDark;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline_rounded,
                size: 36,
                color: isDark
                    ? AppColors.darkOnSurfaceTertiary
                    : AppColors.lightOnSurfaceTertiary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            Text(
              'No profiles yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkOnSurfaceSecondary
                    : AppColors.lightOnSurfaceSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Create a profile to track\nyour BMI journey',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkOnSurfaceTertiary
                    : AppColors.lightOnSurfaceTertiary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusRound),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  AppStrings.btnAddProfile,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile card - premium with avatar initials and active glow
// ---------------------------------------------------------------------------

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard({
    required this.profile,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  final ProfileModel profile;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (profile.id != null) {
          ref.read(profilesProvider.notifier).setActive(profile.id!);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius:
              BorderRadius.circular(AppDimensions.cardBorderRadius),
          border: Border.all(
            color: profile.isActive
                ? AppColors.primary.withValues(alpha: 0.5)
                : (isDark ? AppColors.darkOutline : AppColors.lightOutline),
            width: profile.isActive ? 1.5 : 1,
          ),
          boxShadow: profile.isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Avatar with initials
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: profile.isActive
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : (isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
              alignment: Alignment.center,
              child: Text(
                profile.name.isNotEmpty
                    ? profile.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: profile.isActive
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.darkOnSurfaceSecondary
                          : AppColors.lightOnSurfaceSecondary),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingLg),

            // Name and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (profile.isActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.gender}  ·  ${profile.heightCm.toStringAsFixed(0)} cm',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkOnSurfaceTertiary
                          : AppColors.lightOnSurfaceTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Actions menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz_rounded,
                color: isDark
                    ? AppColors.darkOnSurfaceTertiary
                    : AppColors.lightOnSurfaceTertiary,
                size: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
              color: isDark
                  ? AppColors.darkSurfaceHigh
                  : AppColors.lightSurface,
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18,
                        color: isDark
                            ? AppColors.darkOnSurfaceSecondary
                            : AppColors.lightOnSurfaceSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(AppStrings.btnEditProfile),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 18,
                        color: AppColors.obese,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.btnDelete,
                        style: TextStyle(color: AppColors.obese),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile bottom sheet (replaces dialog for premium feel)
// ---------------------------------------------------------------------------

void _showProfileSheet(
  BuildContext context,
  WidgetRef ref,
  bool isDark, {
  ProfileModel? existing,
}) {
  final nameController = TextEditingController(text: existing?.name ?? '');
  final heightController = TextEditingController(
    text: existing?.heightCm.toStringAsFixed(0) ?? '170',
  );
  String gender = existing?.gender ?? 'Male';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusXxl),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppDimensions.spacingMd),
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkOutline
                          : AppColors.lightOutline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXl),

                  // Title
                  Text(
                    existing == null
                        ? AppStrings.btnAddProfile
                        : AppStrings.btnEditProfile,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Name field
                  _SheetTextField(
                    controller: nameController,
                    label: 'Name',
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // Height field
                  _SheetTextField(
                    controller: heightController,
                    label: 'Height (cm)',
                    icon: Icons.straighten_rounded,
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  // Gender selector
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.lightSurfaceVariant,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkOutline
                            : AppColors.lightOutline,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: ['Male', 'Female'].map((g) {
                        final isSelected = g == gender;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setSheetState(() => gender = g),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSm + 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? AppColors
                                              .darkOnSurfaceSecondary
                                          : AppColors
                                              .lightOnSurfaceSecondary),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: AppDimensions.buttonHeight,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceVariant
                                  : AppColors.lightSurfaceVariant,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.buttonBorderRadius),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkOutline
                                    : AppColors.lightOutline,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.btnCancel,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkOnSurfaceSecondary
                                    : AppColors.lightOnSurfaceSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            final name = nameController.text.trim();
                            final heightVal =
                                double.tryParse(heightController.text) ??
                                    170;

                            if (name.isEmpty) return;

                            final profile = ProfileModel(
                              id: existing?.id,
                              name: name,
                              gender: gender,
                              heightCm: heightVal,
                              dateOfBirth: existing?.dateOfBirth,
                              isActive: existing?.isActive ?? false,
                            );

                            if (existing == null) {
                              ref
                                  .read(profilesProvider.notifier)
                                  .addProfile(profile);
                            } else {
                              ref
                                  .read(profilesProvider.notifier)
                                  .updateProfile(profile);
                            }

                            Navigator.pop(ctx);
                          },
                          child: Container(
                            height: AppDimensions.buttonHeight,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.buttonBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.btnSave,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimensions.spacingXl +
                        MediaQuery.of(ctx).padding.bottom,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Sheet text field - minimal, dark-themed
// ---------------------------------------------------------------------------

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.primary,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.darkOnSurfaceTertiary
              : AppColors.lightOnSurfaceTertiary,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppDimensions.textFieldBorderRadius),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppDimensions.textFieldBorderRadius),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppDimensions.textFieldBorderRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingLg,
        ),
      ),
    );
  }
}
