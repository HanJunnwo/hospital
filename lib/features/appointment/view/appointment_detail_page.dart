import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const AppointmentDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final doctorName = data['doctorName'] as String? ?? 'Dr. Sarah Putri, Sp.JP';
    final specialty = data['specialty'] as String? ?? 'Kardiologi';
    final date = data['date'] as String? ?? 'Senin, 10 Mar 2026';
    final time = data['time'] as String? ?? '09:30 WIB';
    final status = data['status'] as String? ?? 'Mendatang';
    final initials = data['initials'] as String? ?? 'SP';
    final statusColor = status == 'Hari Ini' ? AppColors.primary : status == 'Mendatang' ? AppColors.secondary : AppColors.success;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 16)),
        ),
        title: Text('Detail Janji Temu', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          children: [
            // Doctor card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text(initials, style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctorName, style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(specialty, style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.85))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(AppConstants.radiusFull)),
                    child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informasi Janji', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 16),
                  _DetailRow(icon: Icons.calendar_today_rounded, iconColor: AppColors.primary, label: 'Tanggal', value: date),
                  const Divider(height: 20, color: AppColors.divider),
                  _DetailRow(icon: Icons.access_time_rounded, iconColor: AppColors.secondary, label: 'Waktu', value: time),
                  const Divider(height: 20, color: AppColors.divider),
                  _DetailRow(icon: Icons.local_hospital_outlined, iconColor: AppColors.success, label: 'Lokasi', value: 'RS Cipto Mangunkusumo'),
                  const Divider(height: 20, color: AppColors.divider),
                  _DetailRow(icon: Icons.assignment_outlined, iconColor: AppColors.warning, label: 'No. Antrian', value: '#A-024'),
                  const Divider(height: 20, color: AppColors.divider),
                  _DetailRow(icon: Icons.credit_card_outlined, iconColor: AppColors.info, label: 'Biaya', value: 'Rp 150.000'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: statusColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      status == 'Hari Ini'
                          ? 'Janji temu Anda hari ini. Harap tiba 15 menit sebelum jadwal.'
                          : 'Janji temu Anda sudah dikonfirmasi. Kami akan mengingatkan Anda sebelum jadwal.',
                      style: AppTextStyles.bodySmall.copyWith(color: statusColor, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCancelDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text('Batalkan', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Fitur Reschedule segera hadir', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit_calendar_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text('Reschedule', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Batalkan Janji?', style: AppTextStyles.headlineSmall),
        content: Text('Apakah Anda yakin ingin membatalkan janji temu ini?', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Tidak', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary))),
          GestureDetector(
            onTap: () { Navigator.pop(context); context.pop(); },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
              child: Text('Ya, Batalkan', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 18)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
        Text(value, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
