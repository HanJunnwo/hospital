import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../auth/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) context.go(AppRoutes.login);
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final userName = user?.name ?? 'Raihan Ramadhan';
    final userEmail = user?.email ?? 'raihan@email.com';
    final initials = user?.initials ?? 'RR';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeroHeader(
              userName: userName,
              userEmail: userEmail,
              initials: initials,
              onEdit: () => context.push('/edit-profile'),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Health Card ──────────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _HealthSummaryCard(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Menu Sections ────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(label: 'Akun Saya', icon: Icons.manage_accounts_rounded),
                  const SizedBox(height: 10),
                  _PremiumMenuCard(items: [
                    _PremiumMenuItem(
                      icon: Icons.person_rounded,
                      iconBg: const Color(0xFF0A73E8),
                      label: 'Edit Profil',
                      subtitle: 'Perbarui data diri Anda',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _PremiumMenuItem(
                      icon: Icons.phone_rounded,
                      iconBg: const Color(0xFF8B5CF6),
                      label: 'Nomor Telepon',
                      subtitle: '+62 812 3456 7890',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _PremiumMenuItem(
                      icon: Icons.location_on_rounded,
                      iconBg: const Color(0xFFEF4444),
                      label: 'Alamat',
                      subtitle: 'Medan, Sumatera Utara',
                      onTap: () => context.push('/edit-profile'),
                    ),
                  ]),

                  const SizedBox(height: 20),
                  _SectionHeader(label: 'Layanan', icon: Icons.medical_services_rounded),
                  const SizedBox(height: 10),
                  _PremiumMenuCard(items: [
                    _PremiumMenuItem(
                      icon: Icons.calendar_month_rounded,
                      iconBg: const Color(0xFF00C2A8),
                      label: 'Jadwal Saya',
                      subtitle: '3 janji temu aktif',
                      onTap: () => context.go('/schedule'),
                    ),
                    _PremiumMenuItem(
                      icon: Icons.history_rounded,
                      iconBg: const Color(0xFFF59E0B),
                      label: 'Riwayat Konsultasi',
                      subtitle: '12 konsultasi selesai',
                      onTap: () => context.go('/history'),
                    ),
                    _PremiumMenuItem(
                      icon: Icons.favorite_rounded,
                      iconBg: const Color(0xFFEC4899),
                      label: 'Dokter Favorit',
                      subtitle: '3 dokter disimpan',
                      onTap: () => context.push('/favorites'),
                    ),
                  ]),

                  const SizedBox(height: 20),
                  _SectionHeader(label: 'Pengaturan', icon: Icons.settings_rounded),
                  const SizedBox(height: 10),
                  _PremiumMenuCard(items: [
                    _PremiumMenuItem(
                      icon: Icons.notifications_rounded,
                      iconBg: const Color(0xFF6366F1),
                      label: 'Notifikasi',
                      subtitle: 'Kelola notifikasi Anda',
                      onTap: () => context.push('/notification-settings'),
                    ),
                    _PremiumMenuItem(
                      icon: Icons.lock_rounded,
                      iconBg: const Color(0xFF10B981),
                      label: 'Keamanan',
                      subtitle: 'Password & biometrik',
                      onTap: () => context.push('/security-settings'),
                    ),
                    _PremiumMenuItem(
                      icon: Icons.help_rounded,
                      iconBg: const Color(0xFF0EA5E9),
                      label: 'Bantuan',
                      subtitle: 'Pusat bantuan & FAQ',
                      onTap: () => context.push('/help-center'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Logout ────────────────────────────────────────────
                  _LogoutButton(
                    onTap: () => _showLogoutDialog(context),
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'A-MEDIX v1.0.0',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 28),
            ),
            const SizedBox(height: 12),
            Text('Keluar Akun?', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Text('Batal', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('Keluar', style: AppTextStyles.labelLarge.copyWith(color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hero Header ───────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String initials;
  final VoidCallback onEdit;

  const _HeroHeader({
    required this.userName,
    required this.userEmail,
    required this.initials,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background gradient container
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0557B5), Color(0xFF0A73E8), Color(0xFF00C2A8)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 20, right: 20, bottom: 36,
          ),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profil Saya',
                    style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 5),
                          Text('Edit', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Decorative circles (background)
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: 108, height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
                    ),
                  ),
                  // Avatar
                  Container(
                    width: 92, height: 92,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4DDECA), Color(0xFF00C2A8)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20, offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(initials,
                        style: AppTextStyles.headlineLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  // Camera badge
                  Positioned(
                    bottom: 2, right: 2,
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Text(userName,
                style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email_outlined, color: Colors.white60, size: 13),
                  const SizedBox(width: 4),
                  Text(userEmail, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text('Pasien Terverifikasi',
                      style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stats row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(value: '3', label: 'Janji\nAktif', icon: Icons.calendar_today_rounded),
                    _VertDivider(),
                    _StatItem(value: '12', label: 'Total\nKonsultasi', icon: Icons.assignment_rounded),
                    _VertDivider(),
                    _StatItem(value: '5', label: 'Ulasan\nDiberikan', icon: Icons.star_rounded),
                    _VertDivider(),
                    _StatItem(value: '3', label: 'Dokter\nFavorit', icon: Icons.favorite_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatItem({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white70, fontSize: 9, height: 1.3), textAlign: TextAlign.center),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  const _VertDivider();
  @override
  Widget build(BuildContext context) =>
    Container(width: 1, height: 44, color: Colors.white.withOpacity(0.25));
}

// ── Health Summary Card ───────────────────────────────────────────────────────
class _HealthSummaryCard extends StatelessWidget {
  const _HealthSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.25)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Kesehatan', style: AppTextStyles.titleMedium.copyWith(color: const Color(0xFF166534), fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Kondisi umum Anda baik. Jadwal kontrol berikutnya 30 hari lagi.',
                  style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF15803D), height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Baik', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 7),
        Text(label, style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Premium Menu Card ─────────────────────────────────────────────────────────
class _PremiumMenuCard extends StatelessWidget {
  final List<_PremiumMenuItem> items;
  const _PremiumMenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(20) : Radius.zero,
                  bottom: i == items.length - 1 ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Row(
                    children: [
                      // Colored icon box
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: item.iconBg,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(color: item.iconBg.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      // Labels
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                            if (item.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(item.subtitle!, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                            ],
                          ],
                        ),
                      ),
                      // Arrow
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                const Divider(height: 1, indent: 72, endIndent: 16, color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}

class _PremiumMenuItem {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _PremiumMenuItem({
    required this.icon,
    required this.iconBg,
    required this.label,
    this.subtitle,
    required this.onTap,
  });
}

// ── Logout Button ─────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            const SizedBox(width: 10),
            Text('Keluar dari Akun',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
