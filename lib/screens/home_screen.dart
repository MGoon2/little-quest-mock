import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/app_scaffold.dart';
import '../components/discovery_card.dart';
import '../components/quest_card.dart';
import '../components/section_header.dart';
import '../components/side_menu.dart';
import '../models/discovery_card_item.dart';
import '../models/quest.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'camera_screen.dart';
import 'discovery_card_screen.dart';
import 'quest_detail_screen.dart';

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
      title: '안녕, 시아야! 👋',
      subtitle: '오늘도 새로운 발견을\n기록해볼까?',
      image: 'assets/images/home_banner.png',
      url: 'https://windsurf.com',
    ),
    _BannerData(
      title: '오늘의 퀘스트',
      subtitle: '공원에서 3가지 식물을\n찾아보세요!',
      gradientColors: [AppColors.accentYellowLight, AppColors.accentCoralLight],
      icon: Icons.search,
      routeName: '/discovery-cards',
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
          onPressed: () => _openSideMenu(context),
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
              onAction: () => _openDiscoveryCards(context),
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

    return GestureDetector(
      onTap: () => _onBannerTap(banner),
      child: Container(
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
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'Jua',
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
      ),
    );
  }

  void _onBannerTap(_BannerData banner) {
    if (banner.url != null) {
      _launchUrl(banner.url!);
    } else if (banner.routeName != null) {
      Navigator.of(context).pushNamed(banner.routeName!);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontFamily: 'Jua',
                  ),
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
      _openQuestDetail(context);
      return;
    }
    if (index == 1) {
      _openDiscoveryCards(context);
      return;
    }
    if (index == 3) {
      // 지도 화면 이동
      Navigator.of(context).pushNamed('/map');
      return;
    }
    if (index == 4) {
      Navigator.of(context).pushNamed('/my-page');
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _openSideMenu(BuildContext context) {
    showSideMenu(
      context,
      items: [
        SideMenuItem(
          icon: Icons.home_outlined,
          label: '홈',
          onTap: () {
            // 이미 홈에 있음
          },
        ),
        SideMenuItem(
          icon: Icons.style_outlined,
          label: '도감',
          onTap: () => _openDiscoveryCards(context),
        ),
        SideMenuItem(
          icon: Icons.visibility_outlined,
          label: '관찰',
          onTap: () {},
        ),
        SideMenuItem(
          icon: Icons.flag_outlined,
          label: '퀘스트',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QuestDetailScreen()),
            );
          },
        ),
        SideMenuItem(
          icon: Icons.map_outlined,
          label: '탐험지도',
          onTap: () => Navigator.of(context).pushNamed('/map'),
        ),
        SideMenuItem(
          icon: Icons.person_outline,
          label: '내 정보',
          onTap: () => Navigator.of(context).pushNamed('/my-page'),
        ),
      ],
    );
  }

  void _openCamera(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );
  }

  void _openDiscoveryCards(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DiscoveryCardScreen()),
    );
  }

  void _openQuestDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QuestDetailScreen()),
    );
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
  final String? url;
  final String? routeName;

  const _BannerData({
    required this.title,
    required this.subtitle,
    this.image,
    this.gradientColors,
    this.icon,
    this.url,
    this.routeName,
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
