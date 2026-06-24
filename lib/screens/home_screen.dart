import 'package:flutter/material.dart';

import '../components/app_scaffold.dart';
import '../components/discovery_card.dart';
import '../components/quest_card.dart';
import '../components/section_header.dart';
import '../models/discovery_card_item.dart';
import '../models/quest.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'discovery_intro_screen.dart';
import 'photo_upload_screen.dart';

/// 메인 홈 화면.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Quest> _quests = const [
    Quest(
      id: 'q1',
      title: '초록색 잎을 찾아봐요',
      description: '공원이나 길가에서 다양한 잎을 찾아 사진을 찍어보세요!',
      current: 0,
      total: 3,
    ),
  ];

  final List<DiscoveryCardItem> _discoveries = const [
    DiscoveryCardItem(
      id: 'd1',
      name: '은행나무',
      category: '나무',
      icon: Icons.eco,
      backgroundColor: AppColors.leafLight,
      isNew: false,
    ),
    DiscoveryCardItem(
      id: 'd2',
      name: '진달래',
      category: '꽃',
      icon: Icons.local_florist,
      backgroundColor: AppColors.flowerLight,
      isNew: true,
    ),
    DiscoveryCardItem(
      id: 'd3',
      name: '집고양이',
      category: '동물',
      icon: Icons.pets,
      backgroundColor: AppColors.pawLight,
      isNew: false,
    ),
    DiscoveryCardItem(
      id: 'd4',
      name: '무당벌레',
      category: '곤충',
      icon: Icons.bug_report,
      backgroundColor: AppColors.accentYellowLight,
      isNew: true,
    ),
    DiscoveryCardItem(
      id: 'd5',
      name: '나비',
      category: '곤충',
      icon: Icons.emoji_nature,
      backgroundColor: AppColors.accentCoralLight,
      isNew: false,
    ),
    DiscoveryCardItem(
      id: 'd6',
      name: '토끼',
      category: '동물',
      icon: Icons.cruelty_free,
      backgroundColor: AppColors.pawLight,
      isNew: false,
    ),
    DiscoveryCardItem(
      id: 'd7',
      name: '매미',
      category: '곤충',
      icon: Icons.grass,
      backgroundColor: AppColors.primarySoft,
      isNew: false,
    ),
    DiscoveryCardItem(
      id: 'd8',
      name: '패랭이꽃',
      category: '꽃',
      icon: Icons.water_drop,
      backgroundColor: AppColors.surface,
      isNew: true,
    ),
    DiscoveryCardItem(
      id: 'd9',
      name: '소나무',
      category: '나무',
      icon: Icons.park,
      backgroundColor: AppColors.leafLight,
      isNew: false,
    ),
    DiscoveryCardItem(
      id: 'd10',
      name: '도토리',
      category: '식물',
      icon: Icons.nature,
      backgroundColor: AppColors.accentYellowLight,
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: _currentIndex,
      onNavigationTap: _onNavTap,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Little Quest',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: _buildCameraFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(child: _buildWelcomeBanner()),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.sectionGap),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: '오늘의 퀘스트',
              actionLabel: '전체 보기',
              onAction: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(
            child: QuestCard(
              quest: _quests.first,
              onTap: () => _openQuestDetail(context),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.sectionGap),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: '나의 발견 카드',
              actionLabel: '전체 보기',
              onAction: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 148,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _discoveries.length,
                separatorBuilder: (_, index) => const SizedBox(width: 12),
                itemBuilder: (_, index) => DiscoveryCard(
                  item: _discoveries[index],
                  onTap: () => _openDiscoveryDetail(context, _discoveries[index]),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.sectionGap),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: '탐험 기록',
              actionLabel: '전체 보기',
              onAction: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(child: _buildRecentLogCard()),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.sectionGap + 56),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/home_banner.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '안녕, 자두야! 👋',
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '오늘도 새로운 발견을\n기록해볼까?',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraFab() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: AppShadows.soft,
      ),
      child: FloatingActionButton(
        onPressed: () => _openCamera(context),
        backgroundColor: AppColors.primary,
        elevation: 0,
        child: const Icon(
          Icons.camera_alt,
          color: AppColors.textInverse,
        ),
      ),
    );
  }

  Widget _buildRecentLogCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.location_on,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '서울숲 가족마당',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '2024.05.20 · 12종류 발견',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 2) {
      _openCamera(context);
      return;
    }
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DiscoveryIntroScreen()),
      );
      return;
    }
    if (index == 3) {
      // 지도 화면 이동
      Navigator.of(context).pushNamed('/map');
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _openCamera(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PhotoUploadScreen()),
    );
  }

  void _openQuestDetail(BuildContext context) {
    // 퀘스트 상세
  }

  void _openDiscoveryDetail(BuildContext context, DiscoveryCardItem item) {
    Navigator.of(context).pushNamed(
      '/card-detail',
      arguments: item,
    );
  }
}
