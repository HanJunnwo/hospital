import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Data model untuk satu spesialisasi dokter
class _TrendData {
  final String label;
  final List<double> weeklyValues; // 7 hari
  final Color color;
  final IconData icon;
  final double changePercent;
  final bool isUp;

  const _TrendData({
    required this.label,
    required this.weeklyValues,
    required this.color,
    required this.icon,
    required this.changePercent,
    required this.isUp,
  });
}

/// Section "Tren Dokter" di home page
/// Menampilkan:
/// 1. Tab per spesialisasi (Kardiologi, Mata, Gizi, Bedah)
/// 2. Animated line chart 7 hari (CustomPainter)
/// 3. Info highlight: total booking, peak day, perubahan minggu ini
class DoctorTrendWidget extends StatefulWidget {
  const DoctorTrendWidget({super.key});

  @override
  State<DoctorTrendWidget> createState() => _DoctorTrendWidgetState();
}

class _DoctorTrendWidgetState extends State<DoctorTrendWidget>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animCtrl;
  late Animation<double> _drawAnim;

  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  static const List<_TrendData> _trends = [
    _TrendData(
      label: 'Kardiologi',
      weeklyValues: [42, 55, 48, 72, 65, 58, 80],
      color: Color(0xFF3B82F6),
      icon: Icons.favorite_rounded,
      changePercent: 18.5,
      isUp: true,
    ),
    _TrendData(
      label: 'Mata',
      weeklyValues: [30, 38, 50, 44, 62, 55, 70],
      color: Color(0xFF8B5CF6),
      icon: Icons.visibility_rounded,
      changePercent: 12.3,
      isUp: true,
    ),
    _TrendData(
      label: 'Gizi',
      weeklyValues: [60, 52, 45, 58, 40, 48, 55],
      color: Color(0xFF10B981),
      icon: Icons.restaurant_rounded,
      changePercent: 5.2,
      isUp: false,
    ),
    _TrendData(
      label: 'Bedah',
      weeklyValues: [25, 30, 35, 28, 40, 38, 45],
      color: Color(0xFFF59E0B),
      icon: Icons.medical_services_rounded,
      changePercent: 22.0,
      isUp: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _drawAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    if (_selectedIndex == i) return;
    setState(() => _selectedIndex = i);
    _animCtrl.reset();
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final trend = _trends[_selectedIndex];
    final maxVal = trend.weeklyValues.reduce(math.max);
    final minVal = trend.weeklyValues.reduce(math.min);
    final peakDayIndex =
        trend.weeklyValues.indexOf(trend.weeklyValues.reduce(math.max));
    final totalBookings =
        trend.weeklyValues.fold<double>(0, (a, b) => a + b).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.trending_up_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tren Konsultasi',
                          style: AppTextStyles.titleLarge
                              .copyWith(fontWeight: FontWeight.w700)),
                      Text('7 hari terakhir',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                // Badge "Live"
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Live',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Specialty Tabs ─────────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _trends.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final t = _trends[i];
                final selected = _selectedIndex == i;
                return GestureDetector(
                  onTap: () => _selectTab(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? t.color : t.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: t.color.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(t.icon,
                            color:
                                selected ? Colors.white : t.color,
                            size: 14),
                        const SizedBox(width: 5),
                        Text(
                          t.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: selected ? Colors.white : t.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── Highlight Stats ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _StatBadge(
                  label: 'Total Minggu Ini',
                  value: '$totalBookings',
                  unit: 'pasien',
                  color: trend.color,
                  icon: Icons.people_alt_rounded,
                ),
                const SizedBox(width: 12),
                _StatBadge(
                  label: 'Hari Puncak',
                  value: _days[peakDayIndex],
                  unit: '${maxVal.toInt()} pasien',
                  color: trend.color,
                  icon: Icons.star_rounded,
                ),
                const SizedBox(width: 12),
                _StatBadge(
                  label: 'vs Minggu Lalu',
                  value: '${trend.isUp ? '+' : '-'}${trend.changePercent.toStringAsFixed(1)}%',
                  unit: trend.isUp ? 'naik' : 'turun',
                  color: trend.isUp ? AppColors.success : AppColors.error,
                  icon: trend.isUp
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Line Chart ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _drawAnim,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 160),
                  painter: _LineChartPainter(
                    values: trend.weeklyValues,
                    labels: _days,
                    color: trend.color,
                    progress: _drawAnim.value,
                    maxVal: maxVal,
                    minVal: minVal,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Stat Badge ─────────────────────────────────────────────────────────────────
class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            Text(
              unit,
              style: AppTextStyles.labelSmall.copyWith(
                color: color.withOpacity(0.75),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Painter: Line Chart ──────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final double progress; // 0.0 → 1.0 for draw animation
  final double maxVal;
  final double minVal;

  _LineChartPainter({
    required this.values,
    required this.labels,
    required this.color,
    required this.progress,
    required this.maxVal,
    required this.minVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double topPad = 12;
    const double bottomPad = 28;
    const double leftPad = 4;
    const double rightPad = 4;

    final chartH = size.height - topPad - bottomPad;
    final chartW = size.width - leftPad - rightPad;
    final n = values.length;
    final range = maxVal - minVal;
    final safeRange = range < 1 ? 1 : range;

    // Compute point positions
    List<Offset> points = [];
    for (int i = 0; i < n; i++) {
      final x = leftPad + (i / (n - 1)) * chartW;
      final normY = (values[i] - minVal) / safeRange;
      final y = topPad + chartH - (normY * chartH);
      points.add(Offset(x, y));
    }

    // ── Animated clip: draw from left to right ────────────────────────────────
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    // ── Gradient Fill ─────────────────────────────────────────────────────────
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height - bottomPad);
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final curr = points[i];
        final cpX = (prev.dx + curr.dx) / 2;
        fillPath.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
      }
    }
    fillPath.lineTo(points.last.dx, size.height - bottomPad);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.22),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // ── Line ──────────────────────────────────────────────────────────────────
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        linePath.moveTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final curr = points[i];
        final cpX = (prev.dx + curr.dx) / 2;
        linePath.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
      }
    }
    canvas.drawPath(linePath, linePaint);

    canvas.restore();

    // ── Grid Lines (horizontal, dashed) ───────────────────────────────────────
    final gridPaint = Paint()
      ..color = const Color(0xFFE8EDF5)
      ..strokeWidth = 1;
    const gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final y = topPad + (chartH / gridCount) * i;
      _drawDashedLine(canvas, Offset(leftPad, y),
          Offset(leftPad + chartW, y), gridPaint);
    }

    // ── Dots & Value labels ───────────────────────────────────────────────────
    if (progress > 0.85) {
      final opacity = ((progress - 0.85) / 0.15).clamp(0.0, 1.0);
      for (int i = 0; i < points.length; i++) {
        final pt = points[i];
        final isMax = values[i] == maxVal;

        // Outer glow for peak
        if (isMax) {
          final glowPaint = Paint()
            ..color = color.withOpacity(0.2 * opacity)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(pt, 12, glowPaint);
        }

        // Outer ring
        final outerPaint = Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, isMax ? 6 : 4.5, outerPaint);

        // White center
        final innerPaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, isMax ? 3.5 : 2.5, innerPaint);

        // Value label above peak dot
        if (isMax) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: '${values[i].toInt()}',
              style: TextStyle(
                color: color.withOpacity(opacity),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          final labelX = pt.dx - textPainter.width / 2;
          final labelY = pt.dy - 20;
          // Bubble background
          final bubbleRect = RRect.fromRectAndRadius(
            Rect.fromLTWH(labelX - 6, labelY - 2, textPainter.width + 12, 16),
            const Radius.circular(6),
          );
          canvas.drawRRect(
            bubbleRect,
            Paint()..color = color.withOpacity(0.12 * opacity),
          );
          textPainter.paint(canvas, Offset(labelX, labelY));
        }
      }
    }

    // ── X-Axis Day Labels ─────────────────────────────────────────────────────
    for (int i = 0; i < n; i++) {
      final x = leftPad + (i / (n - 1)) * chartW;
      final isToday = i == n - 1;
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: isToday ? color : const Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 18),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dashW = 4.0;
    const gapW = 4.0;
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    final cosA = dx / len;
    final sinA = dy / len;
    double dist = 0;
    bool drawing = true;
    while (dist < len) {
      final segLen = drawing ? dashW : gapW;
      final end = math.min(dist + segLen, len);
      if (drawing) {
        canvas.drawLine(
          Offset(from.dx + cosA * dist, from.dy + sinA * dist),
          Offset(from.dx + cosA * end, from.dy + sinA * end),
          paint,
        );
      }
      dist = end;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.values != values;
}
