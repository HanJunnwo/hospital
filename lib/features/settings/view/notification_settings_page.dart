import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});
  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _appointmentReminder = true;
  bool _appointmentConfirmation = true;
  bool _healthTips = true;
  bool _promoOffers = false;
  bool _doctorUpdates = true;
  bool _emailNotif = false;
  bool _smsNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 16),
          ),
        ),
        title: Text('Pengaturan Notifikasi', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          _buildSectionCard(
            title: 'Pengingat Janji Temu',
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.primary,
            description: 'Kelola notifikasi terkait janji temu dan jadwal dokter Anda',
            children: [
              _buildToggleItem(
                label: 'Pengingat Janji Temu',
                subtitle: 'Ingatkan saya sebelum jadwal konsultasi',
                value: _appointmentReminder,
                onChanged: (v) => setState(() => _appointmentReminder = v),
              ),
              _buildDivider(),
              _buildToggleItem(
                label: 'Konfirmasi Janji Temu',
                subtitle: 'Notifikasi saat janji temu dikonfirmasi',
                value: _appointmentConfirmation,
                onChanged: (v) => setState(() => _appointmentConfirmation = v),
              ),
              _buildDivider(),
              _buildToggleItem(
                label: 'Update Dokter',
                subtitle: 'Info jadwal terbaru dokter favorit',
                value: _doctorUpdates,
                onChanged: (v) => setState(() => _doctorUpdates = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Konten & Promosi',
            icon: Icons.campaign_outlined,
            iconColor: AppColors.secondary,
            description: 'Notifikasi tips kesehatan dan penawaran spesial',
            children: [
              _buildToggleItem(
                label: 'Tips Kesehatan',
                subtitle: 'Artikel dan saran kesehatan harian',
                value: _healthTips,
                onChanged: (v) => setState(() => _healthTips = v),
              ),
              _buildDivider(),
              _buildToggleItem(
                label: 'Promo & Penawaran',
                subtitle: 'Diskon dan promo layanan kesehatan',
                value: _promoOffers,
                onChanged: (v) => setState(() => _promoOffers = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Saluran Notifikasi',
            icon: Icons.send_outlined,
            iconColor: AppColors.warning,
            description: 'Pilih cara menerima notifikasi',
            children: [
              _buildToggleItem(
                label: 'Notifikasi Email',
                subtitle: 'Terima notifikasi via email',
                value: _emailNotif,
                onChanged: (v) => setState(() => _emailNotif = v),
              ),
              _buildDivider(),
              _buildToggleItem(
                label: 'Notifikasi SMS',
                subtitle: 'Terima pengingat via SMS',
                value: _smsNotif,
                onChanged: (v) => setState(() => _smsNotif = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Pengaturan notifikasi disimpan', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ));
            },
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Center(child: Text('Simpan Pengaturan', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Color iconColor, required String description, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 2),
                      Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleItem({required String label, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 16, color: AppColors.divider);
}
