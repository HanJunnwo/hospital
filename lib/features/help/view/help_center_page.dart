import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

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
        title: Text('Bantuan', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          _buildFaqItem(
            question: 'Bagaimana cara membatalkan janji temu?',
            answer: 'Anda dapat membatalkan janji temu melalui menu "Jadwal Saya", lalu pilih janji temu yang ingin dibatalkan dan klik tombol "Batalkan". Harap dicatat bahwa pembatalan harus dilakukan minimal 24 jam sebelum jadwal.',
          ),
          const SizedBox(height: 12),
          _buildFaqItem(
            question: 'Bagaimana cara mengubah profil?',
            answer: 'Buka menu Profil, lalu klik "Edit Profil". Anda dapat mengubah nama, email, nomor telepon, dan data pribadi lainnya di halaman tersebut.',
          ),
          const SizedBox(height: 12),
          _buildFaqItem(
            question: 'Apakah saya bisa mengubah jadwal (reschedule)?',
            answer: 'Ya, Anda bisa mengubah jadwal konsultasi. Pilih janji temu di menu "Jadwal Saya", lalu klik "Reschedule" dan pilih waktu baru yang tersedia.',
          ),
          const SizedBox(height: 24),
          Text('Butuh bantuan lebih lanjut?', style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  context,
                  icon: Icons.chat_outlined,
                  title: 'Live Chat',
                  subtitle: 'Tersedia 24/7',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContactCard(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'Balasan 1x24 jam',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))]),
      child: ExpansionTile(
        title: Text(question, style: AppTextStyles.labelLarge),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: [
          Text(answer, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Menghubungkan ke $title...', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))], border: Border.all(color: color.withOpacity(0.3))),
        child: Column(
          children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
