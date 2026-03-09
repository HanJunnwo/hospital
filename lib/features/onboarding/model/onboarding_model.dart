import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
  });
}

class OnboardingData {
  static const List<OnboardingModel> items = [
    OnboardingModel(
      title: 'Layanan Kesehatan\nTerbaik',
      description:
          'Dapatkan akses layanan kesehatan berkualitas tinggi dengan mudah dan cepat di mana saja.',
      icon: Icons.health_and_safety_rounded,
      primaryColor: Color(0xFF0A73E8),
      accentColor: Color(0xFF4DA3FF),
    ),
    OnboardingModel(
      title: 'Pilih Dokter\nSpesialis',
      description:
          'Temukan dokter spesialis terpercaya sesuai kebutuhanmu dan buat janji temu kapan saja.',
      icon: Icons.person_search_rounded,
      primaryColor: Color(0xFF00C2A8),
      accentColor: Color(0xFF4DDECA),
    ),
    OnboardingModel(
      title: 'Pantau Kesehatan\nAnda',
      description:
          'Lihat riwayat pemeriksaan, hasil lab, dan kelola jadwal konsultasi dalam satu aplikasi.',
      icon: Icons.monitor_heart_rounded,
      primaryColor: Color(0xFF8B5CF6),
      accentColor: Color(0xFFA78BFA),
    ),
  ];
}
