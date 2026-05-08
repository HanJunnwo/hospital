import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Raihan Ramadhan');
  final _emailCtrl = TextEditingController(text: 'raihan@email.com');
  final _phoneCtrl = TextEditingController(text: '+62 812 3456 7890');
  final _addressCtrl = TextEditingController(text: 'Medan, Sumatera Utara');
  final _dobCtrl = TextEditingController(text: '15 Agustus 1995');
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profil berhasil diperbarui', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
    context.pop();
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
          child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 16)),
        ),
        title: Text('Edit Profil', style: AppTextStyles.titleLarge),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.divider)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF00C2A8), Color(0xFF4DDECA)]),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: const Offset(0, 4))],
                      ),
                      child: Center(child: Text('RR', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Pribadi', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 16),
                    _buildField(label: 'Nama Lengkap', ctrl: _nameCtrl, icon: Icons.person_outline_rounded,
                      validator: (v) => (v?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null),
                    const SizedBox(height: 14),
                    _buildField(label: 'Email', ctrl: _emailCtrl, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v?.contains('@') ?? false) ? null : 'Email tidak valid'),
                    const SizedBox(height: 14),
                    _buildField(label: 'Nomor Telepon', ctrl: _phoneCtrl, icon: Icons.phone_outlined, keyboardType: TextInputType.phone,
                      validator: (v) => (v?.isEmpty ?? true) ? 'Nomor telepon tidak boleh kosong' : null),
                    const SizedBox(height: 14),
                    _buildField(label: 'Tanggal Lahir', ctrl: _dobCtrl, icon: Icons.cake_outlined, readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(context: context, initialDate: DateTime(1995, 8, 15), firstDate: DateTime(1940), lastDate: DateTime.now());
                        if (picked != null) {
                          final months = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
                          _dobCtrl.text = '${picked.day} ${months[picked.month-1]} ${picked.year}';
                        }
                      }),
                    const SizedBox(height: 14),
                    _buildField(label: 'Alamat', ctrl: _addressCtrl, icon: Icons.location_on_outlined, maxLines: 2),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Save button
              GestureDetector(
                onTap: _isSaving ? null : _save,
                child: Container(
                  width: double.infinity, height: 54,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Center(
                    child: _isSaving
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : Text('Simpan Perubahan', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
          ),
        ),
      ],
    );
  }
}
