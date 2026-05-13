import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class _NotifItem {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  bool isRead;
  _NotifItem({required this.icon, required this.color, required this.title, required this.message, required this.time, required this.isRead});
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<_NotifItem> _items = [
    _NotifItem(icon: Icons.calendar_today_rounded, color: AppColors.primary, title: 'Janji Temu Dikonfirmasi', message: 'Janji temu dengan Dr. Sarah Putri, Sp.JP pada Senin, 10 Mar 2026 pukul 09:30 WIB telah dikonfirmasi.', time: '5 menit lalu', isRead: false),
    _NotifItem(icon: Icons.access_time_rounded, color: AppColors.warning, title: 'Pengingat Janji Temu', message: 'Anda memiliki janji temu besok dengan Dr. Ahmad Rizki, Sp.M pukul 14:00 WIB. Jangan lupa!', time: '1 jam lalu', isRead: false),
    _NotifItem(icon: Icons.local_offer_rounded, color: AppColors.secondary, title: 'Promo Kesehatan', message: 'Dapatkan diskon 20% untuk konsultasi pertama dengan dokter spesialis pilihan Anda.', time: '3 jam lalu', isRead: true),
    _NotifItem(icon: Icons.check_circle_rounded, color: AppColors.success, title: 'Konsultasi Selesai', message: 'Konsultasi dengan Dr. Dewi Lestari, Sp.PD telah selesai. Berikan ulasan Anda.', time: '1 hari lalu', isRead: true),
    _NotifItem(icon: Icons.medication_rounded, color: const Color(0xFF8B5CF6), title: 'Pengingat Obat', message: 'Jangan lupa minum obat Anda sesuai resep dari dokter. Pantau kondisi kesehatan Anda.', time: '2 hari lalu', isRead: true),
    _NotifItem(icon: Icons.health_and_safety_rounded, color: AppColors.primary, title: 'Tips Kesehatan', message: 'Minum air putih minimal 8 gelas per hari untuk menjaga kesehatan tubuh Anda setiap hari.', time: '3 hari lalu', isRead: true),
  ];

  int get _unread => _items.where((n) => !n.isRead).length;

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
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 16)),
        ),
        title: Text('Notifikasi', style: AppTextStyles.titleLarge),
        actions: [
          if (_unread > 0)
            TextButton(
              onPressed: () => setState(() { for (var n in _items) { n.isRead = true; } }),
              child: Text('Tandai Semua', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
            ),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final n = _items[i];
          return GestureDetector(
            onTap: () {
              setState(() => n.isRead = true);
              _showNotificationDetail(context, n);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: n.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: n.isRead ? null : Border.all(color: AppColors.primary.withOpacity(0.15)),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: n.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(n.icon, color: n.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(child: Text(n.title, style: AppTextStyles.labelLarge.copyWith(fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700))),
                          if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                        ]),
                        const SizedBox(height: 4),
                        Text(n.message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text(n.time, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, _NotifItem n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 32),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: n.color.withOpacity(0.1), 
                  shape: BoxShape.circle,
                  border: Border.all(color: n.color.withOpacity(0.2), width: 2),
                ),
                child: Icon(n.icon, color: n.color, size: 40),
              ),
              const SizedBox(height: 24),
              Text(n.title, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(n.time, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(color: AppColors.cardShadow.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      n.message, 
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary, height: 1.6), 
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Tutup', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
