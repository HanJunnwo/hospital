import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

enum AppointmentStatus { today, upcoming, done, cancelled }

class _AppointmentData {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final AppointmentStatus status;
  final String initials;

  const _AppointmentData({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
    required this.initials,
  });
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late List<_AppointmentData> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = [
      const _AppointmentData(
        doctorName: 'Dr. Sarah Putri, Sp.JP',
        specialty: 'Kardiologi',
        date: 'Senin, 10 Mar 2026',
        time: '09:30 WIB',
        status: AppointmentStatus.upcoming,
        initials: 'SP',
      ),
      const _AppointmentData(
        doctorName: 'Dr. Ahmad Rizki, Sp.M',
        specialty: 'Mata',
        date: 'Kamis, 13 Mar 2026',
        time: '14:00 WIB',
        status: AppointmentStatus.upcoming,
        initials: 'AR',
      ),
      const _AppointmentData(
        doctorName: 'Dr. Dewi Lestari, Sp.PD',
        specialty: 'Penyakit Dalam',
        date: 'Senin, 9 Mar 2026',
        time: '16:30 WIB',
        status: AppointmentStatus.today,
        initials: 'DL',
      ),
    ];
  }

  List<_AppointmentData> get _todayAppointments =>
      _appointments.where((a) => a.status == AppointmentStatus.today).toList();

  List<_AppointmentData> get _upcomingAppointments =>
      _appointments.where((a) => a.status == AppointmentStatus.upcoming).toList();

  void _cancelAppointment(_AppointmentData appointment) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Batalkan Janji?', style: AppTextStyles.headlineSmall),
        content: Text(
          'Apakah Anda yakin ingin membatalkan janji temu dengan ${appointment.doctorName} pada ${appointment.date}?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tidak', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setState(() => _appointments.remove(appointment));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Janji temu dengan ${appointment.doctorName} telah dibatalkan.',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Ya, Batalkan', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Jadwal Saya', style: AppTextStyles.titleLarge),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          GestureDetector(
            onTap: () => context.push('/all-doctors'),
            child: Container(
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text('Buat Janji', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: _appointments.isEmpty
          ? _buildEmptyState(context)
          : ListView(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              children: [
                // Date header
                _DateHeader(totalAppointments: _appointments.length),
                const SizedBox(height: 20),

                // Today section
                if (_todayAppointments.isNotEmpty) ...[
                  const _SectionTitle('Hari Ini', icon: Icons.today_rounded),
                  const SizedBox(height: 12),
                  ..._todayAppointments.map((apt) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AppointmentCard(
                      appointment: apt,
                      onCancel: () => _cancelAppointment(apt),
                      onDetail: () => context.push('/appointment-detail', extra: {
                        'doctorName': apt.doctorName,
                        'specialty': apt.specialty,
                        'date': apt.date,
                        'time': apt.time,
                        'status': apt.status == AppointmentStatus.today ? 'Hari Ini' : 'Mendatang',
                        'initials': apt.initials,
                      }),
                    ),
                  )),
                  const SizedBox(height: 12),
                ],

                // Upcoming section
                if (_upcomingAppointments.isNotEmpty) ...[
                  const _SectionTitle('Mendatang', icon: Icons.schedule_rounded),
                  const SizedBox(height: 12),
                  ..._upcomingAppointments.map((apt) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AppointmentCard(
                      appointment: apt,
                      onCancel: () => _cancelAppointment(apt),
                      onDetail: () => context.push('/appointment-detail', extra: {
                        'doctorName': apt.doctorName,
                        'specialty': apt.specialty,
                        'date': apt.date,
                        'time': apt.time,
                        'status': apt.status == AppointmentStatus.today ? 'Hari Ini' : 'Mendatang',
                        'initials': apt.initials,
                      }),
                    ),
                  )),
                ],

                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.08), AppColors.primary.withOpacity(0.12)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text('Belum Ada Jadwal', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Buat janji temu dengan dokter terbaik\nkami sekarang.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => context.push('/all-doctors'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Cari Dokter & Buat Janji', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final int totalAppointments;
  const _DateHeader({required this.totalAppointments});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maret 2026',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$totalAppointments janji temu bulan ini',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle(this.title, {required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.titleLarge),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final _AppointmentData appointment;
  final VoidCallback onCancel;
  final VoidCallback onDetail;

  const _AppointmentCard({
    required this.appointment,
    required this.onCancel,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = switch (appointment.status) {
      AppointmentStatus.today => ('Hari Ini', AppColors.primary),
      AppointmentStatus.upcoming => ('Mendatang', AppColors.secondary),
      AppointmentStatus.done => ('Selesai', AppColors.success),
      AppointmentStatus.cancelled => ('Dibatalkan', AppColors.error),
    };

    return GestureDetector(
      onTap: onDetail,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
          border: appointment.status == AppointmentStatus.today
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5)
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEBF1FF), Color(0xFFD6E6FF)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      appointment.initials,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
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
                      Text(
                        appointment.doctorName,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.specialty,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoChip(icon: Icons.calendar_today_outlined, label: appointment.date),
                const SizedBox(width: 16),
                _InfoChip(icon: Icons.access_time_rounded, label: appointment.time),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            if (appointment.status == AppointmentStatus.upcoming ||
                appointment.status == AppointmentStatus.today)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: Text(
                        'Batalkan',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onDetail,
                      icon: const Icon(Icons.info_outline_rounded, size: 16),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      label: Text(
                        'Detail',
                        style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}
