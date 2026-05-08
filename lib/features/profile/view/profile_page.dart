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
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
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
    final userEmail = user?.email ?? '';
    final initials = user?.initials ?? 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header gradient
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 32,
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C2A8), Color(0xFF4DDECA)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (userEmail.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Stats row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(label: 'Janji', value: '3'),
                      SizedBox(width: 24),
                      _StatChip(label: 'Riwayat', value: '12'),
                      SizedBox(width: 24),
                      _StatChip(label: 'Ulasan', value: '5'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Menu sections
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('Akun Saya'),
                  const SizedBox(height: 8),
                  _MenuCard(items: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profil',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    _MenuItem(
                      icon: Icons.phone_outlined,
                      label: 'Nomor Telepon',
                      value: '+62 xxx xxxx xxxx',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Ubah nomor telepon di Edit Profil', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                        ));
                      },
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Alamat',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Ubah alamat di Edit Profil', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                        ));
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),
                  const _SectionLabel('Layanan'),
                  const SizedBox(height: 8),
                  _MenuCard(items: [
                    _MenuItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Jadwal Saya',
                      onTap: () => context.go('/schedule'),
                    ),
                    _MenuItem(
                      icon: Icons.assignment_outlined,
                      label: 'Riwayat Konsultasi',
                      onTap: () => context.go('/history'),
                    ),
                    _MenuItem(
                      icon: Icons.favorite_outline_rounded,
                      label: 'Dokter Favorit',
                      onTap: () => context.push('/favorites'),
                    ),
                  ]),

                  const SizedBox(height: 20),
                  const _SectionLabel('Pengaturan'),
                  const SizedBox(height: 8),
                  _MenuCard(items: [
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifikasi',
                      onTap: () => context.push('/notification-settings'),
                    ),
                    _MenuItem(
                      icon: Icons.lock_outline_rounded,
                      label: 'Keamanan',
                      onTap: () => context.push('/security-settings'),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Bantuan',
                      onTap: () => context.push('/help-center'),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthLogoutRequested());
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(
                        'Keluar',
                        style: AppTextStyles.titleMedium
                            .copyWith(color: AppColors.error),
                      ),
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
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
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
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.titleLarge.copyWith(color: AppColors.textSecondary),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
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
                  top: i == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: i == items.length - 1
                      ? const Radius.circular(16)
                      : Radius.zero,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(item.icon, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child:
                            Text(item.label, style: AppTextStyles.bodyMedium),
                      ),
                      if (item.value != null)
                        Text(
                          item.value!,
                          style: AppTextStyles.labelMedium,
                        ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                const Divider(height: 1, indent: 66, color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.value,
    required this.onTap,
  });
}
