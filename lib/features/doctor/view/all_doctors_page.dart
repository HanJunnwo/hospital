import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';
import '../../home/model/doctor_model.dart';
import '../../home/model/category_model.dart';
import '../../home/view/widgets/doctor_card.dart';

class AllDoctorsPage extends StatefulWidget {
  const AllDoctorsPage({super.key});
  @override
  State<AllDoctorsPage> createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  int _selectedCategory = 0;
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DoctorModel> get _filtered {
    var list = DoctorData.items;
    if (_query.isNotEmpty) {
      list = list.where((d) =>
          d.name.toLowerCase().contains(_query.toLowerCase()) ||
          d.specialty.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    if (_selectedCategory > 0) {
      final cats = CategoryData.items;
      if (_selectedCategory < cats.length) {
        final catName = cats[_selectedCategory].name.toLowerCase();
        list = list.where((d) => d.specialty.toLowerCase().contains(catName.split(' ').first.toLowerCase())).toList();
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cats = CategoryData.items.map((c) => c.name).toList();

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
        title: Text('Semua Dokter', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Cari dokter atau spesialis...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? GestureDetector(
                        onTap: () { _searchCtrl.clear(); setState(() => _query = ''); },
                        child: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20))
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
          ),
          // Category filter
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
              itemCount: cats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final sel = _selectedCategory == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: sel ? AppColors.primaryGradient : null,
                      color: sel ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                      border: sel ? null : Border.all(color: AppColors.border),
                    ),
                    child: Text(cats[i], style: AppTextStyles.labelMedium.copyWith(color: sel ? Colors.white : AppColors.textSecondary, fontWeight: sel ? FontWeight.w600 : FontWeight.w500)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM, vertical: 4),
            child: Row(children: [
              Text('${_filtered.length} dokter ditemukan', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ]),
          ),
          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.search_off_rounded, size: 56, color: AppColors.textHint),
                      const SizedBox(height: 12),
                      Text('Dokter tidak ditemukan', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ]),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => context.push('/doctor/${_filtered[i].id}'),
                      child: DoctorCard(doctor: _filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
