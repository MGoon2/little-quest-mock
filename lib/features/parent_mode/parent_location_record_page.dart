import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_map_preview_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_section_card.dart';

class ParentLocationRecordPage extends StatefulWidget {
  const ParentLocationRecordPage({super.key});

  @override
  State<ParentLocationRecordPage> createState() =>
      _ParentLocationRecordPageState();
}

class _ParentLocationRecordPageState extends State<ParentLocationRecordPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '위치 기록 관리'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LocationTabs(
                labels: const ['지도 보기', '장소 목록', '기록 설정'],
                selectedIndex: _selectedTab,
                onChanged: (index) => setState(() => _selectedTab = index),
              ),
              const SizedBox(height: 18),
              const ParentMapPreviewCard(pins: ParentModeFixture.locationPins),
              const SizedBox(height: 18),
              ParentSectionCard(
                backgroundColor: LqColors.warning.withValues(alpha: 0.62),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '관찰 장소 수',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 13,
                              color: LqColors.textDark,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '24곳',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: LqColors.textDark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '가장 최근 관찰: 2024.05.20',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 12,
                              color: LqColors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.eco,
                      size: 58,
                      color: LqColors.mutedGreen.withValues(alpha: 0.58),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 위치 기록 조회 API 연결
                    // TODO: 위치 기록 설정 화면 연결
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LqColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(
                    '위치 기록 설정',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _LocationTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final selected = index == selectedIndex;
        return Expanded(
          child: InkWell(
            onTap: () => onChanged(index),
            child: Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: selected ? 2 : 1,
                    color: selected ? LqColors.primaryGreen : LqColors.border,
                  ),
                ),
              ),
              child: Text(
                labels[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected ? LqColors.primaryGreen : LqColors.textSubtle,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
