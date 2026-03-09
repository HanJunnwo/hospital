import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static final List<_HistoryItem> _items = [
    _HistoryItem(
      doctorName: 'Dr. Sarah Putri, Sp.JP',
      specialty: 'Kardiologi',
      date: 'Senin, 3 Mar 2026',
      diagnosis: 'Pemeriksaan Jantung Rutin',
      initials: 'SP',
      isCured: true,
    ),
    _HistoryItem(
      doctorName: 'Dr. Ahmad Rizki, Sp.M',
      specialty: 'Mata',
      date: 'Jumat, 21 Feb 2026',
      diagnosis: 'Pemeriksaan Minus Mata',
      initials: 'AR',
      isCured: true,
    ),
    _HistoryItem(
      doctorName: 'Dr. Dewi Lestari, Sp.PD',
      specialty: 'Penyakit Dalam',
      date: 'Selasa, 4 Feb 2026',
      diagnosis: 'Cek Kesehatan Umum',
      initials: 'DL',
      isCured: false,
    ),
    _HistoryItem(
      doctorName: 'Dr. Rudi Setiawan, Sp.B',
      specialty: 'Bedah Umum',
      date: 'Kamis, 15 Jan 2026',
      diagnosis: 'Konsultasi Pasca Operasi',
      initials: 'BS',
      isCured: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Riwayat Konsultasi', style: AppTextStyles.titleLarge),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00B4A0), Color(0xFF00C2A8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Konsultasi',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_items.length}',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Konsultasi selesai',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _SummaryBadge(label: 'Dokter', value: '4'),
                    const SizedBox(height: 8),
                    _SummaryBadge(label: 'Follow-up', value: '1'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('Semua Riwayat', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),

          // History list
          ..._items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _HistoryCard(item: item),
              )),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall
                .copyWith(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem {
  final String doctorName;
  final String specialty;
  final String date;
  final String diagnosis;
  final String initials;
  final bool isCured;

  const _HistoryItem({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.diagnosis,
    required this.initials,
    required this.isCured,
  });
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEBF1FF), Color(0xFFD6E6FF)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                item.initials,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.doctorName,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.specialty,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    item.diagnosis,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 11, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(item.date, style: AppTextStyles.labelSmall),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Status
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isCured
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  item.isCured ? 'Selesai' : 'Follow-up',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: item.isCured ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.textHint,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
