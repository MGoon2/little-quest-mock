import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';

/// SDK 연결 전 위치 기록 지도 placeholder.
class ParentMapPreviewCard extends StatelessWidget {
  final List<ParentLocationPin> pins;

  const ParentMapPreviewCard({super.key, required this.pins});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE6F0DD),
            border: Border.all(color: LqColors.border),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              return Stack(
                children: [
                  const Positioned.fill(child: _MapPlaceholderBackground()),
                  ...pins.map(
                    (pin) => Positioned(
                      left: width * pin.dx - 14,
                      top: height * pin.dy - 28,
                      child: Tooltip(
                        message: pin.label,
                        child: const Icon(
                          Icons.location_on,
                          size: 34,
                          color: LqColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: width * 0.48 - 24,
                    top: height * 0.58 - 24,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED).withValues(alpha: 0.24),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F80ED),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '장소/동 단위로 표시',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: LqColors.deepGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholderBackground extends StatelessWidget {
  const _MapPlaceholderBackground();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFD6E9C8),
      child: Stack(
        children: [
          const Positioned(
            left: -28,
            right: -28,
            top: 42,
            child: _MapBand(height: 28, angle: 0.38, color: Color(0xFFBFDCE7)),
          ),
          const Positioned(
            left: -18,
            right: -18,
            top: 74,
            child: _MapBand(height: 7, angle: 0.08, color: Colors.white),
          ),
          Positioned(
            left: -18,
            right: -18,
            top: 142,
            child: _MapBand(
              height: 7,
              angle: 0.08,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          Positioned(
            left: 52,
            top: -24,
            bottom: -24,
            child: _MapBand(
              width: 4,
              angle: -0.18,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          Positioned(
            right: 72,
            top: -24,
            bottom: -24,
            child: _MapBand(
              width: 4,
              angle: -0.18,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBand extends StatelessWidget {
  final double? width;
  final double? height;
  final double angle;
  final Color color;

  const _MapBand({
    this.width,
    this.height,
    required this.angle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
