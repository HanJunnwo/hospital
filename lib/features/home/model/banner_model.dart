import 'package:flutter/material.dart';

class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
  });
}

class BannerData {
  static const List<BannerModel> items = [
    BannerModel(
      id: 'b1',
      title: 'Konsultasi Gratis\nHari Ini!',
      subtitle: 'Untuk pengguna baru. Berlaku s.d. 31 Maret',
      primaryColor: Color(0xFF0A73E8),
      accentColor: Color(0xFF00C2A8),
      icon: Icons.volunteer_activism_rounded,
    ),
    BannerModel(
      id: 'b2',
      title: 'Cek Kesehatan\nLengkap',
      subtitle: 'Paket medical check-up mulai Rp 150.000',
      primaryColor: Color(0xFF8B5CF6),
      accentColor: Color(0xFFEC4899),
      icon: Icons.health_and_safety_rounded,
    ),
    BannerModel(
      id: 'b3',
      title: 'Vaksin &\nImunisasi',
      subtitle: 'Jadwal vaksinasi tersedia di seluruh cabang',
      primaryColor: Color(0xFF00C2A8),
      accentColor: Color(0xFF0A73E8),
      icon: Icons.vaccines_rounded,
    ),
  ];
}
