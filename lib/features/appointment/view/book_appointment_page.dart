import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../home/model/doctor_model.dart';

class BookAppointmentPage extends StatefulWidget {
  final String doctorId;
  const BookAppointmentPage({super.key, required this.doctorId});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  int _selectedDateIndex = 0;
  String? _selectedTime;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  final List<String> _times = [
    '08:00', '09:00', '10:00', '11:00',
    '13:00', '14:00', '15:00', '16:00',
  ];

  List<Map<String, String>> _getNext14Days() {
    final days = <Map<String, String>>[];
    final dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    for (int i = 0; i < 14; i++) {
      final date = DateTime.now().add(Duration(days: i));
      days.add({
        'day': dayNames[date.weekday % 7],
        'date': '${date.day}',
        'month': monthNames[date.month - 1],
      });
    }
    return days;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _confirmBooking(BuildContext context, DoctorModel doctor) async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih waktu konsultasi terlebih dahulu',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSuccessDialog(context, doctor);
  }

  void _showSuccessDialog(BuildContext context, DoctorModel doctor) {
    final dates = _getNext14Days();
    final selected = dates[_selectedDateIndex];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
              const SizedBox(height: 20),
              Text('Janji Temu Berhasil!',
                  style: AppTextStyles.headlineSmall
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Janji temu dengan ${doctor.name} telah dikonfirmasi.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _ConfirmRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Dokter',
                      value: doctor.name,
                    ),
                    const SizedBox(height: 8),
                    _ConfirmRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal',
                      value:
                          '${selected['day']}, ${selected['date']} ${selected['month']}',
                    ),
                    const SizedBox(height: 8),
                    _ConfirmRow(
                      icon: Icons.access_time_rounded,
                      label: 'Waktu',
                      value: '$_selectedTime WIB',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.schedule);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text('Lihat Jadwal Saya',
                        style: AppTextStyles.titleMedium
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorData.items.firstWhere(
      (d) => d.id == widget.doctorId,
      orElse: () => DoctorData.items.first,
    );
    final dates = _getNext14Days();

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
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 16),
          ),
        ),
        title: Text('Buat Janji Temu', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        doctor.avatarInitials ?? doctor.name[0],
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.name,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(doctor.specialty,
                            style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.85))),
                        const SizedBox(height: 2),
                        Text(doctor.hospital,
                            style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white.withOpacity(0.7)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFF59E0B), size: 13),
                        const SizedBox(width: 3),
                        Text(doctor.rating.toStringAsFixed(1),
                            style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date picker
            Text('Pilih Tanggal', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final selected = _selectedDateIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedDateIndex = i;
                      _selectedTime = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 54,
                      decoration: BoxDecoration(
                        gradient:
                            selected ? AppColors.primaryGradient : null,
                        color: selected ? null : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: selected
                                ? AppColors.primary.withOpacity(0.3)
                                : AppColors.cardShadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dates[i]['day']!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: selected
                                  ? Colors.white.withOpacity(0.85)
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dates[i]['date']!,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: selected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Time slot
            Text('Pilih Waktu', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.0,
              ),
              itemCount: _times.length,
              itemBuilder: (context, i) {
                final selected = _selectedTime == _times[i];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedTime = _times[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient:
                          selected ? AppColors.primaryGradient : null,
                      color: selected ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: selected
                          ? null
                          : Border.all(color: AppColors.border),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color:
                                    AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        _times[i],
                        style: AppTextStyles.labelSmall.copyWith(
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Notes
            Text('Catatan (Opsional)', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText:
                    'Contoh: Ada keluhan nyeri dada sejak 2 hari lalu...',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Confirm button
            GestureDetector(
              onTap: _isLoading
                  ? null
                  : () => _confirmBooking(context, doctor),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Konfirmasi Janji Temu',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ConfirmRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text('$label: ',
            style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.textSecondary)),
        Expanded(
          child: Text(value,
              style: AppTextStyles.labelMedium
                  .copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

// AppRoutes imported from core router
