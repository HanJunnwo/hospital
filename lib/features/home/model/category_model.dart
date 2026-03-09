import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CategoryData {
  static const List<CategoryModel> items = [
    CategoryModel(
      id: 'all',
      name: 'Semua',
      icon: Icons.grid_view_rounded,
      color: Color(0xFF0A73E8),
    ),
    CategoryModel(
      id: 'general',
      name: 'Umum',
      icon: Icons.medical_services_rounded,
      color: Color(0xFF0A73E8),
    ),
    CategoryModel(
      id: 'dentist',
      name: 'Gigi',
      icon: Icons.mood_rounded,
      color: Color(0xFF8B5CF6),
    ),
    CategoryModel(
      id: 'heart',
      name: 'Jantung',
      icon: Icons.favorite_rounded,
      color: Color(0xFFEF4444),
    ),
    CategoryModel(
      id: 'child',
      name: 'Anak',
      icon: Icons.child_care_rounded,
      color: Color(0xFFF59E0B),
    ),
    CategoryModel(
      id: 'eye',
      name: 'Mata',
      icon: Icons.visibility_rounded,
      color: Color(0xFF00C2A8),
    ),
    CategoryModel(
      id: 'bone',
      name: 'Tulang',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFF6366F1),
    ),
    CategoryModel(
      id: 'skin',
      name: 'Kulit',
      icon: Icons.spa_rounded,
      color: Color(0xFFEC4899),
    ),
  ];
}
