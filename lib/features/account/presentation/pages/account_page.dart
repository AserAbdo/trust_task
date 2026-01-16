import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/language_cubit.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

/// Account Page - User profile, settings, and app information
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(context, l10n),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _ProfileSection(l10n: l10n),
            const SizedBox(height: 24),
            _QuickActionsSection(l10n: l10n),
            const SizedBox(height: 24),
            _SettingsSection(l10n: l10n),
            const SizedBox(height: 24),
            _AboutSection(l10n: l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppTheme.brownPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l10n.translate('account'),
        style: const TextStyle(
          color: AppTheme.brownPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Profile Section - Avatar, name, login button
class _ProfileSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _ProfileSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with gradient border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Guest Label
          Text(
            l10n.translate('guest_user'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.brownPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            l10n.translate('login_for_more'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Login & Register Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showComingSoon(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.translate('login'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showComingSoon(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    l10n.translate('register'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translate('coming_soon')),
        backgroundColor: AppTheme.brownPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Quick Actions Section - Orders, Favorites, Addresses
class _QuickActionsSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _QuickActionsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickActionItem(
            icon: Icons.receipt_long_rounded,
            label: l10n.translate('my_orders'),
            onTap: () => _showComingSoon(context),
          ),
          _buildDivider(),
          _QuickActionItem(
            icon: Icons.favorite_rounded,
            label: l10n.translate('favorites'),
            onTap: () => _showComingSoon(context),
          ),
          _buildDivider(),
          _QuickActionItem(
            icon: Icons.location_on_rounded,
            label: l10n.translate('my_addresses'),
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 50, color: Colors.grey.shade200);
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translate('coming_soon')),
        backgroundColor: AppTheme.brownPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.brownPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings Section - Language, Notifications, Address
class _SettingsSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _SettingsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              l10n.translate('settings'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.brownPrimary,
              ),
            ),
          ),
          const Divider(height: 1),

          // Language Setting with Toggle
          _LanguageSettingTile(l10n: l10n),
          const Divider(height: 1, indent: 72),

          // Notifications Setting
          _SettingTile(
            icon: Icons.notifications_rounded,
            title: l10n.translate('notifications'),
            subtitle: l10n.translate('receive_updates'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
          const Divider(height: 1, indent: 72),

          // Delivery Address
          _SettingTile(
            icon: Icons.location_on_rounded,
            title: l10n.translate('delivery_address'),
            subtitle: l10n.translate('set_your_address'),
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1, indent: 72),

          // Payment Methods
          _SettingTile(
            icon: Icons.payment_rounded,
            title: l10n.translate('payment_methods'),
            subtitle: l10n.translate('manage_payments'),
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translate('coming_soon')),
        backgroundColor: AppTheme.brownPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Language Setting Tile with proper toggle
class _LanguageSettingTile extends StatelessWidget {
  final AppLocalizations l10n;

  const _LanguageSettingTile({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.language_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          title: Text(
            l10n.translate('language'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.brownPrimary,
            ),
          ),
          subtitle: Text(
            isArabic ? l10n.translate('arabic') : l10n.translate('english'),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          trailing: _LanguageToggle(isArabic: isArabic),
        );
      },
    );
  }
}

/// Creative Language Toggle with Flag Design
class _LanguageToggle extends StatelessWidget {
  final bool isArabic;

  const _LanguageToggle({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<LanguageCubit>().toggleLanguage();
      },
      child: Container(
        width: 100,
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade200, Colors.grey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated Pill Selector
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 46,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            // Language Options Row - Always LTR to keep EN on left, ع on right
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // English Option (always on left)
                  _buildLanguageOption(
                    flag: '🇬🇧',
                    label: 'EN',
                    isSelected: !isArabic,
                  ),
                  // Arabic Option (always on right)
                  _buildLanguageOption(
                    flag: '🇸🇦',
                    label: 'ع',
                    isSelected: isArabic,
                    isArabicFont: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String label,
    required bool isSelected,
    bool isArabicFont = false,
  }) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: isArabicFont ? 16 : 13,
        fontWeight: FontWeight.w800,
        color: isSelected ? Colors.white : Colors.grey.shade500,
        shadows: isSelected
            ? [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
      child: SizedBox(
        width: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(label)],
        ),
      ),
    );
  }
}

/// Reusable Setting Tile Widget
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.brownPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing:
          trailing ??
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}

/// About Section - App info, policies, contact
class _AboutSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _AboutSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              l10n.translate('about'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.brownPrimary,
              ),
            ),
          ),
          const Divider(height: 1),

          _InfoTile(
            icon: Icons.info_outline_rounded,
            title: l10n.translate('about_app'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),

          _InfoTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.translate('privacy_policy'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),

          _InfoTile(
            icon: Icons.description_outlined,
            title: l10n.translate('terms_conditions'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),

          _InfoTile(
            icon: Icons.headset_mic_outlined,
            title: l10n.translate('contact_us'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),

          _InfoTile(
            icon: Icons.star_outline_rounded,
            title: l10n.translate('rate_app'),
            onTap: () {},
          ),

          // App Version
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '${l10n.translate('version')} 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Info Tile for About Section
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: AppTheme.brownPrimary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.brownPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}
