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

  final Map<String, List<String>> _timeSlots = {
    'Pagi': ['08:00', '09:00', '10:00', '11:00'],
    'Siang': ['13:00', '14:00', '15:00'],
    'Sore/Malam': ['16:00', '17:00', '19:00'],
  };

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
        'fullDate': date.toIso8601String(),
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
          content: Text('Silakan pilih waktu konsultasi terlebih dahulu',
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
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(0.1),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 32, bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.success, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColors.success,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Booking Berhasil!',
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Janji temu Anda telah dikonfirmasi dan dijadwalkan.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border.withOpacity(0.5)),
                        ),
                        child: Column(
                          children: [
                            _ConfirmRow(
                              icon: Icons.person_outline_rounded,
                              label: 'Dokter',
                              value: doctor.name,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1, color: AppColors.divider),
                            ),
                            _ConfirmRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'Tanggal',
                              value: '${selected['day']}, ${selected['date']} ${selected['month']}',
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1, color: AppColors.divider),
                            ),
                            _ConfirmRow(
                              icon: Icons.access_time_rounded,
                              label: 'Waktu',
                              value: '$_selectedTime WIB',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.go(AppRoutes.schedule);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Lihat Jadwal Saya',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 18),
          ),
        ),
        title: Text('Buat Janji Temu', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern Doctor Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              doctor.avatarInitials ?? doctor.name[0],
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doctor.name,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('${doctor.specialty} • ${doctor.hospital}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFBEB),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                                        const SizedBox(width: 4),
                                        Text(doctor.rating.toStringAsFixed(1),
                                            style: AppTextStyles.labelSmall.copyWith(
                                                color: const Color(0xFFB45309),
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${doctor.reviewCount} Ulasan', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pilih Tanggal', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                      Text('${dates[_selectedDateIndex]['month']} 2026', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Modern Date Picker
                  SizedBox(
                    height: 85,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final selected = _selectedDateIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedDateIndex = i;
                            _selectedTime = null;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            width: 65,
                            decoration: BoxDecoration(
                              gradient: selected ? AppColors.primaryGradient : null,
                              color: selected ? null : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: selected ? null : Border.all(color: AppColors.border),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  i == 0 ? 'Hari Ini' : i == 1 ? 'Besok' : dates[i]['day']!,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: selected
                                        ? Colors.white.withOpacity(0.9)
                                        : (i == 0 || i == 1 ? AppColors.primary : AppColors.textSecondary),
                                    fontWeight: selected || i == 0 || i == 1 ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dates[i]['date']!,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    color: selected ? Colors.white : AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Time Slots Grouped
                  Text('Waktu Tersedia', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  ..._timeSlots.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                entry.key == 'Pagi' ? Icons.wb_sunny_outlined 
                                : entry.key == 'Siang' ? Icons.light_mode_outlined 
                                : Icons.nightlight_round,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(entry.key, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: entry.value.map((time) {
                              final selected = _selectedTime == time;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedTime = time),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: selected ? AppColors.primaryGradient : null,
                                    color: selected ? null : AppColors.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: selected ? null : Border.all(color: AppColors.border),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Text(
                                    time,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: selected ? Colors.white : AppColors.textPrimary,
                                      fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // Notes Field
                  Text('Catatan Keluhan (Opsional)', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Deskripsikan gejala yang Anda rasakan untuk membantu dokter...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: GestureDetector(
                onTap: _isLoading ? null : () => _confirmBooking(context, doctor),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ConfirmRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
