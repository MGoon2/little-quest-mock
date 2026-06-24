import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
import 'camera_screen.dart';

/// 메인 홈 화면.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

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

  final List<_BannerData> _banners = const [
    _BannerData(
      title: '안녕, 자두야! 👋',
      subtitle: '오늘도 새로운 발견을\n기록해볼까?',
      image: 'assets/images/home_banner.png',
    ),
    _BannerData(
      title: '오늘의 퀘스트',
      subtitle: '공원에서 3가지 식물을\n찾아보세요!',
      gradientColors: [AppColors.accentYellowLight, AppColors.accentCoralLight],
      icon: Icons.search,
    ),
  ];

  final List<_LogData> _logs = const [
    _LogData(title: '서울숲 가족마당', date: '2024.05.20', count: 12),
    _LogData(title: '올림픽공원', date: '2024.05.18', count: 8),
    _LogData(title: '남산공원', date: '2024.05.15', count: 15),
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
          style: AppTextStyles.logo,
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
          SliverToBoxAdapter(child: _buildBannerArea()),
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
          SliverToBoxAdapter(child: _buildLogCardArea()),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.sectionGap + 56),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerArea() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (index) =>
                setState(() => _currentBannerIndex = index),
            itemBuilder: (_, index) => _buildBanner(_banners[index]),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPageIndicator(_banners.length, _currentBannerIndex),
      ],
    );
  }

  Widget _buildBanner(_BannerData banner) {
    Decoration? decoration;
    if (banner.image != null) {
      decoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage(banner.image!),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      );
    } else if (banner.gradientColors != null) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.gradientColors!,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: decoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  banner.subtitle,
                  style: GoogleFonts.jua(
                    textStyle: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (banner.icon != null)
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.backgroundElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                banner.icon,
                size: 36,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int count, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: index == currentIndex ? 16 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? AppColors.primary
                : AppColors.divider,
          ),
        );
      }),
    );
  }

  Widget _buildCameraFab() {
    return SizedBox(
      width: 48,
      height: 48,
      child: FloatingActionButton(
        onPressed: () => _openCamera(context),
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera_alt,
          color: AppColors.textInverse,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLogCardArea() {
    return SizedBox(
      height: 88,
      child: PageView.builder(
        itemCount: _logs.length,
        itemBuilder: (_, index) => _buildLogCard(_logs[index]),
      ),
    );
  }

  Widget _buildLogCard(_LogData log) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  log.title,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${log.date} · ${log.count}종류 발견',
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
      MaterialPageRoute(builder: (_) => const CameraScreen()),
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

class _BannerData {
  final String title;
  final String subtitle;
  final String? image;
  final List<Color>? gradientColors;
  final IconData? icon;

  const _BannerData({
    required this.title,
    required this.subtitle,
    this.image,
    this.gradientColors,
    this.icon,
  });
}

class _LogData {
  final String title;
  final String date;
  final int count;

  const _LogData({
    required this.title,
    required this.date,
    required this.count,
  });
}
