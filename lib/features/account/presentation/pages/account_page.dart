import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubit/language_cubit.dart';
import '../../../../core/l10n/app_localizations.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  // Colors matching the design
  static const Color linenColor = Color(0xFFFAF0E6);
  static const Color darkBrown = Color(0xFF412216);
  static const Color redColor = Color(0xFFCE1330);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: linenColor,
      appBar: AppBar(
        backgroundColor: linenColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.translate('account'),
          style: const TextStyle(
            color: darkBrown,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Section
            _buildProfileSection(context, l10n),
            const SizedBox(height: 24),

            // Settings Section
            _buildSettingsSection(context, l10n),
            const SizedBox(height: 24),

            // App Info Section
            _buildAppInfoSection(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: redColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 40, color: redColor),
          ),
          const SizedBox(height: 16),
          // Guest Label
          Text(
            l10n.translate('guest_user'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: darkBrown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('login_for_more'),
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to login
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.translate('coming_soon')),
                    backgroundColor: darkBrown,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.translate('settings'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkBrown,
              ),
            ),
          ),
          const Divider(height: 1),

          // Language Setting
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              final isArabic = state.locale.languageCode == 'ar';
              return _buildSettingTile(
                icon: Icons.language,
                title: l10n.translate('language'),
                subtitle: isArabic ? 'العربية' : 'English',
                trailing: Switch(
                  value: isArabic,
                  onChanged: (value) {
                    context.read<LanguageCubit>().toggleLanguage();
                  },
                  activeColor: redColor,
                ),
              );
            },
          ),
          const Divider(height: 1),

          // Notifications Setting
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: l10n.translate('notifications'),
            subtitle: l10n.translate('receive_updates'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement notifications toggle
              },
              activeColor: redColor,
            ),
          ),
          const Divider(height: 1),

          // Location Setting
          _buildSettingTile(
            icon: Icons.location_on_outlined,
            title: l10n.translate('delivery_address'),
            subtitle: l10n.translate('set_your_address'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate('coming_soon')),
                  backgroundColor: darkBrown,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: redColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: redColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkBrown,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildAppInfoSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.translate('about'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkBrown,
              ),
            ),
          ),
          const Divider(height: 1),

          _buildInfoTile(
            icon: Icons.info_outline,
            title: l10n.translate('about_app'),
            onTap: () {},
          ),
          const Divider(height: 1),

          _buildInfoTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.translate('privacy_policy'),
            onTap: () {},
          ),
          const Divider(height: 1),

          _buildInfoTile(
            icon: Icons.description_outlined,
            title: l10n.translate('terms_conditions'),
            onTap: () {},
          ),
          const Divider(height: 1),

          _buildInfoTile(
            icon: Icons.support_agent,
            title: l10n.translate('contact_us'),
            onTap: () {},
          ),

          // App Version
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '${l10n.translate('version')} 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: darkBrown, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: darkBrown,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
