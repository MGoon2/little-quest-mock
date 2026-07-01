import 'package:flutter/material.dart';

import '../features/card_detail/data/card_detail_fixtures.dart';
import '../features/card_detail/models/card_detail_data.dart';
import '../features/card_detail/widgets/card_detail_bottom_action_bar.dart';
import '../features/card_detail/widgets/discovery_hero_card.dart';
import '../features/card_detail/widgets/discovery_record_card.dart';
import '../features/card_detail/widgets/holo_progress_card.dart';
import '../features/card_detail/widgets/observation_history_card.dart';
import 'package:little_quest/app/theme/app_colors.dart';
import 'package:little_quest/app/theme/app_spacing.dart';
import 'package:little_quest/app/theme/app_text_styles.dart';

/// 카드 상세 페이지.
///
/// 발견한 대상의 대표 카드, 발견 기록, Holo 등급, 관찰 기록, 그리고
/// 지도 보기 / 더 관찰하기 / 좋아요 액션을 보여준다.
class DiscoveryCardDetailScreen extends StatefulWidget {
  final CardDetailData? data;

  const DiscoveryCardDetailScreen({super.key, this.data});

  @override
  State<DiscoveryCardDetailScreen> createState() =>
      _DiscoveryCardDetailScreenState();
}

class _DiscoveryCardDetailScreenState extends State<DiscoveryCardDetailScreen> {
  late CardDetailData _data;

  @override
  void initState() {
    super.initState();
    // TODO: 백엔드 API 연결 후에는 repository에서 데이터를 받아온다.
    _data = widget.data ?? sampleCardDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('카드 상세', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: AppColors.textPrimary,
            ),
            // TODO: 카드 공유 기능 연결
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ).copyWith(bottom: AppSpacing.screenPadding),
        child: Column(
          children: [
            DiscoveryHeroCard(data: _data),
            const SizedBox(height: AppSpacing.sectionGap),
            DiscoveryRecordCard(
              record: _data.discoveryRecord,
              // TODO: 발견 기록 상세 또는 지도/기록 상세로 이동
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            HoloProgressCard(data: _data),
            const SizedBox(height: AppSpacing.sectionGap),
            ObservationHistoryCard(
              observations: _data.observations,
              onAddObservation: _onObserveMore,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CardDetailBottomActionBar(
        isFavorite: _data.isFavorite,
        // TODO: Map page로 이동
        onViewMap: () {},
        // TODO: 현재 canonical subject를 context로 카메라 페이지 이동
        onObserveMore: _onObserveMore,
        // TODO: favorite toggle API 연결
        onToggleFavorite: _onToggleFavorite,
      ),
    );
  }

  void _onObserveMore() {
    // TODO: 현재 canonical subject를 context로 카메라 페이지 이동.
    //       예: 은행나무를 더 관찰해볼까요?
    //       잎, 줄기, 주변 모습을 더 자세히 찍어보세요.
  }

  void _onToggleFavorite() {
    setState(() {
      _data = CardDetailData(
        id: _data.id,
        nameKo: _data.nameKo,
        nameEn: _data.nameEn,
        categoryLabel: _data.categoryLabel,
        subCategoryLabel: _data.subCategoryLabel,
        currentGrade: _data.currentGrade,
        oneLineDescription: _data.oneLineDescription,
        discoveryRecord: _data.discoveryRecord,
        nextGradeConditions: _data.nextGradeConditions,
        observations: _data.observations,
        isFavorite: !_data.isFavorite,
      );
    });
    // TODO: favorite 상태를 서버에 저장
  }
}
