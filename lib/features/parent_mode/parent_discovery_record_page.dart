import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/app_radius.dart';
import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/fixtures/parent_mode_fixture.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_app_bar.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_record_summary_card.dart';
import 'package:little_quest/features/parent_mode/widgets/parent_recent_photo_grid.dart';

class ParentDiscoveryRecordPage extends StatefulWidget {
  const ParentDiscoveryRecordPage({super.key});

  @override
  State<ParentDiscoveryRecordPage> createState() =>
      _ParentDiscoveryRecordPageState();
}

class _ParentDiscoveryRecordPageState extends State<ParentDiscoveryRecordPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const ParentAppBar(title: '탐험 기록 관리'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ParentTabs(
                labels: const ['사진 및 카드', '퀘스트 기록', '배지 및 도감'],
                selectedIndex: _selectedTab,
                onChanged: (index) => setState(() => _selectedTab = index),
              ),
              const SizedBox(height: 18),
              const Text(
                '전체 요약',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: LqColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              const ParentRecordSummaryCard(
                summary: ParentModeFixture.recordSummary,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '최근 사진',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: LqColors.textDark,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: 사진/카드 기록 조회 API 연결
                    },
                    child: const Text(
                      '전체 보기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        color: LqColors.textSubtle,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const ParentRecentPhotoGrid(
                photos: ParentModeFixture.recentPhotos,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 사진/카드 관리 화면 연결
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LqColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(
                    '사진 및 카드 관리',
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

class _ParentTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _ParentTabs({
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
