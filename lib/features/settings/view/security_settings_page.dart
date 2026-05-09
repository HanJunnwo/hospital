import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});
  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _biometricAuth = true;
  bool _twoFactorAuth = false;

  // ─── Ubah Password Dialog ───────────────────────────────────────────────────
  void _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool isOldVisible = false;
    bool isNewVisible = false;
    bool isConfirmVisible = false;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(height: 12),
                Text('Ubah Password', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPasswordField(
                      context: context,
                      ctrl: oldPassCtrl,
                      label: 'Password Lama',
                      isVisible: isOldVisible,
                      onToggle: () => setDialogState(() => isOldVisible = !isOldVisible),
                      validator: (v) => (v == null || v.isEmpty) ? 'Password lama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildPasswordField(
                      context: context,
                      ctrl: newPassCtrl,
                      label: 'Password Baru',
                      isVisible: isNewVisible,
                      onToggle: () => setDialogState(() => isNewVisible = !isNewVisible),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password baru tidak boleh kosong';
                        if (v.length < 8) return 'Minimal 8 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPasswordField(
                      context: context,
                      ctrl: confirmPassCtrl,
                      label: 'Konfirmasi Password',
                      isVisible: isConfirmVisible,
                      onToggle: () => setDialogState(() => isConfirmVisible = !isConfirmVisible),
                      validator: (v) => v != newPassCtrl.text ? 'Password tidak cocok' : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(context),
                child: Text('Batal', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
              ),
              GestureDetector(
                onTap: isSaving
                    ? null
                    : () async {
                        if (!(formKey.currentState?.validate() ?? false)) return;
                        setDialogState(() => isSaving = true);
                        await Future.delayed(const Duration(milliseconds: 1200));
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password berhasil diubah', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                        ));
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSaving ? null : AppColors.primaryGradient,
                    color: isSaving ? AppColors.textHint : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : Text('Simpan', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Ubah PIN Dialog ────────────────────────────────────────────────────────
  void _showChangePinDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPinCtrl = TextEditingController();
    final newPinCtrl = TextEditingController();
    final confirmPinCtrl = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pin_outlined, color: AppColors.secondary, size: 26),
                ),
                const SizedBox(height: 12),
                Text('Ubah PIN', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Masukkan PIN 6 digit', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPinField(
                    label: 'PIN Lama',
                    ctrl: oldPinCtrl,
                    validator: (v) => (v == null || v.length != 6) ? 'PIN harus 6 digit' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildPinField(
                    label: 'PIN Baru',
                    ctrl: newPinCtrl,
                    validator: (v) {
                      if (v == null || v.length != 6) return 'PIN harus 6 digit';
                      if (v == oldPinCtrl.text) return 'PIN baru harus berbeda';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPinField(
                    label: 'Konfirmasi PIN Baru',
                    ctrl: confirmPinCtrl,
                    validator: (v) => v != newPinCtrl.text ? 'PIN tidak cocok' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(context),
                child: Text('Batal', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
              ),
              GestureDetector(
                onTap: isSaving
                    ? null
                    : () async {
                        if (!(formKey.currentState?.validate() ?? false)) return;
                        setDialogState(() => isSaving = true);
                        await Future.delayed(const Duration(milliseconds: 1000));
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('PIN berhasil diubah', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                        ));
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSaving ? AppColors.textHint : AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : Text('Simpan PIN', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController ctrl,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: !isVisible,
      validator: validator,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 20),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
      ),
    );
  }

  Widget _buildPinField({
    required String label,
    required TextEditingController ctrl,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 6,
      validator: validator,
      style: AppTextStyles.titleLarge.copyWith(letterSpacing: 8),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        counterText: '',
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.secondary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
      ),
    );
  }

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
        title: Text('Keamanan', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        children: [
          // Password & PIN Section
          _buildSectionCard(
            title: 'Kata Sandi & PIN',
            icon: Icons.lock_outline_rounded,
            iconColor: AppColors.primary,
            description: 'Kelola password dan PIN untuk keamanan akun Anda',
            children: [
              _buildActionItem(
                icon: Icons.lock_outline_rounded,
                iconColor: AppColors.primary,
                label: 'Ubah Password',
                subtitle: 'Perbarui kata sandi akun Anda',
                onTap: _showChangePasswordDialog,
              ),
              _buildDivider(),
              _buildActionItem(
                icon: Icons.pin_outlined,
                iconColor: AppColors.secondary,
                label: 'Ubah PIN',
                subtitle: 'Perbarui PIN 6 digit Anda',
                onTap: _showChangePinDialog,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Biometric & 2FA Section
          _buildSectionCard(
            title: 'Autentikasi Lanjutan',
            icon: Icons.security_rounded,
            iconColor: AppColors.success,
            description: 'Lapisan keamanan tambahan untuk melindungi akun',
            children: [
              _buildToggleItem(
                icon: Icons.fingerprint_rounded,
                iconColor: AppColors.primary,
                label: 'Login Biometrik',
                subtitle: 'Gunakan sidik jari atau wajah',
                value: _biometricAuth,
                onChanged: (v) {
                  setState(() => _biometricAuth = v);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      v ? 'Login biometrik diaktifkan' : 'Login biometrik dinonaktifkan',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                    ),
                    backgroundColor: v ? AppColors.success : AppColors.textSecondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ));
                },
              ),
              _buildDivider(),
              _buildToggleItem(
                icon: Icons.security_rounded,
                iconColor: AppColors.warning,
                label: 'Autentikasi 2 Langkah',
                subtitle: 'Verifikasi OTP setiap login',
                value: _twoFactorAuth,
                onChanged: (v) {
                  setState(() => _twoFactorAuth = v);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      v ? '2FA berhasil diaktifkan' : '2FA dinonaktifkan',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                    ),
                    backgroundColor: v ? AppColors.success : AppColors.textSecondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ));
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String description,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 2),
                      Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 70, color: AppColors.divider);
}
