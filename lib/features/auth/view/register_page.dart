import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import 'widgets/auth_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              confirmPassword: _confirmPassController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.home);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                // Background header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00B4A0),
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -40,
                          right: -40,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        children: [
                          // Top bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => context.pop(),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Buat Akun Baru',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 40),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  // Card
                                  Container(
                                    padding: const EdgeInsets.all(28),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.cardShadow,
                                          blurRadius: 32,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Daftar',
                                            style: AppTextStyles.headlineMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Isi informasi di bawah untuk membuat akun baru.',
                                            style:
                                                AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          // Name
                                          AuthTextField(
                                            label: 'Nama Lengkap',
                                            hint: 'Masukkan nama lengkap',
                                            controller: _nameController,
                                            prefixIcon:
                                                Icons.person_outline_rounded,
                                            validator: (v) {
                                              if (v == null || v.trim().isEmpty) {
                                                return 'Nama tidak boleh kosong';
                                              }
                                              if (v.trim().length < 3) {
                                                return 'Nama minimal 3 karakter';
                                              }
                                              return null;
                                            },
                                          ),

                                          const SizedBox(height: 18),

                                          // Email
                                          AuthTextField(
                                            label: 'Email',
                                            hint: 'Masukkan email valid',
                                            controller: _emailController,
                                            prefixIcon: Icons.email_outlined,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (v) {
                                              if (v == null || v.trim().isEmpty) {
                                                return 'Email tidak boleh kosong';
                                              }
                                              if (!v.contains('@')) {
                                                return 'Format email tidak valid';
                                              }
                                              return null;
                                            },
                                          ),

                                          const SizedBox(height: 18),

                                          // Password
                                          AuthTextField(
                                            label: 'Password',
                                            hint: 'Minimal 6 karakter',
                                            controller: _passwordController,
                                            prefixIcon:
                                                Icons.lock_outline_rounded,
                                            isPassword: true,
                                            validator: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Password tidak boleh kosong';
                                              }
                                              if (v.length < 6) {
                                                return 'Password minimal 6 karakter';
                                              }
                                              return null;
                                            },
                                          ),

                                          const SizedBox(height: 18),

                                          // Confirm password
                                          AuthTextField(
                                            label: 'Konfirmasi Password',
                                            hint: 'Ulangi password',
                                            controller: _confirmPassController,
                                            prefixIcon:
                                                Icons.lock_outline_rounded,
                                            isPassword: true,
                                            textInputAction: TextInputAction.done,
                                            onEditingComplete: () =>
                                                _onRegister(context),
                                            validator: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Konfirmasi password tidak boleh kosong';
                                              }
                                              if (v != _passwordController.text) {
                                                return 'Password tidak cocok';
                                              }
                                              return null;
                                            },
                                          ),

                                          const SizedBox(height: 28),

                                          // Register Button
                                          SizedBox(
                                            width: double.infinity,
                                            height: 54,
                                            child: isLoading
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFF00B4A0),
                                                          AppColors.secondary,
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    child: const Center(
                                                      child: SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.5,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                            Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () =>
                                                        _onRegister(context),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            Color(0xFF00B4A0),
                                                            AppColors.secondary,
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                14),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .secondary
                                                                .withOpacity(
                                                                    0.35),
                                                            blurRadius: 16,
                                                            offset: const Offset(
                                                                0, 6),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Daftar Sekarang',
                                                          style: AppTextStyles
                                                              .titleMedium
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),

                                          const SizedBox(height: 24),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sudah punya akun? ',
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => context.pop(),
                                                child: Text(
                                                  'Masuk',
                                                  style: AppTextStyles.labelMedium
                                                      .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
