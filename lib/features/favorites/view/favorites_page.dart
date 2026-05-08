import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';
import '../../home/model/doctor_model.dart';
import '../../home/view/widgets/doctor_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<DoctorModel> _favorites = [
    DoctorData.items[0],
    DoctorData.items[1],
    DoctorData.items[3],
  ];

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
        title: Text('Dokter Favorit', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border_rounded, size: 40, color: AppColors.textHint),
                  ),
                  const SizedBox(height: 16),
                  Text('Belum Ada Dokter Favorit', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  Text('Tambahkan dokter ke favorit dari halaman detail', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.push('/all-doctors'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)),
                      child: Text('Cari Dokter', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              itemCount: _favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => Stack(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/doctor/${_favorites[i].id}'),
                    child: DoctorCard(doctor: _favorites[i]),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _favorites.removeAt(i)),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.favorite_rounded, color: AppColors.error, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
