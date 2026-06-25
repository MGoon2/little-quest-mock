import 'package:flutter/material.dart';

import '../components/discovery_mini_card.dart';
import '../components/primary_button.dart';
import '../data/discovery_repository.dart';
import '../models/discovery_card.dart';
import '../models/discovery_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 나의 발견 카드 페이지.
///
/// 카테고리별로 발견한 카드를 조회할 수 있다.
class DiscoveryCardScreen extends StatefulWidget {
  const DiscoveryCardScreen({super.key});

  @override
  State<DiscoveryCardScreen> createState() => _DiscoveryCardScreenState();
}

class _DiscoveryCardScreenState extends State<DiscoveryCardScreen> {
  final _repository = const DiscoveryRepository();
  DiscoveryCategory _selectedCategory = DiscoveryCategory.all;
  List<DiscoveryCardGroup>? _groups;
  List<DiscoveryCard>? _cards;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (_selectedCategory == DiscoveryCategory.all) {
      final groups = await _repository.fetchAllGrouped();
      if (mounted) {
        setState(() => _groups = groups);
      }
    } else {
      final cards = await _repository.fetchByCategory(_selectedCategory);
      if (mounted) {
        setState(() => _cards = cards);
      }
    }
  }

  void _onCategoryChanged(DiscoveryCategory category) {
    setState(() {
      _selectedCategory = category;
      _groups = null;
      _cards = null;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('나의 발견 카드', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 검색 기능
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              SliverToBoxAdapter(child: _buildCategorySelector()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              SliverToBoxAdapter(child: _buildSummaryBanner()),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.sectionGap),
              ),
              if (_selectedCategory == DiscoveryCategory.all)
                _buildGroupedList()
              else
                _buildCategoryGrid(),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
              SliverToBoxAdapter(child: _buildCtaBanner()),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return GestureDetector(
      onTap: () => _showCategoryBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: AppShadows.card,
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _selectedCategory.icon,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(_selectedCategory.label, style: AppTextStyles.bodyMedium),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('카테고리 선택', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.lg),
                ...DiscoveryCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ListTile(
                    leading: Icon(
                      category.icon,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      category.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      _onCategoryChanged(category);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCategory.summaryTitle,
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _selectedCategory.summarySubtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Icon(
              _selectedCategory.icon,
              size: 36,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList() {
    final groups = _groups;
    if (groups == null) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(group),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: DiscoveryMiniCard.cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
                itemCount: group.cards.length,
                separatorBuilder: (_, index) => const SizedBox(width: 12),
                itemBuilder: (_, cardIndex) => DiscoveryMiniCard(
                  card: group.cards[cardIndex],
                  onTap: () => Navigator.of(context).pushNamed('/card-detail'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        );
      }, childCount: groups.length),
    );
  }

  Widget _buildSectionHeader(DiscoveryCardGroup group) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: group.category.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(group.category.icon, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.category.sectionTitle, style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.xs),
              Text(
                group.category.sectionDescription,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _onCategoryChanged(group.category),
          child: Row(
            children: [
              Text(
                '전체 보기',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final cards = _cards;
    if (cards == null) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCategory.sectionTitle,
                style: AppTextStyles.heading,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      '최신순',
                      style: AppTextStyles.captionMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _selectedCategory.sectionDescription,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: cards.length,
                itemBuilder: (_, index) => DiscoveryMiniCard(
                  card: cards[index],
                  onTap: () => Navigator.of(context).pushNamed('/card-detail'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCtaBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '더 많은 ${_selectedCategory == DiscoveryCategory.all ? '자연' : _selectedCategory.label}을 발견해보세요!',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '새로운 ${_selectedCategory == DiscoveryCategory.all ? '발견' : _selectedCategory.label}을 발견하면 사진으로 기록해보세요.',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: '사진 찍기',
            icon: const Icon(Icons.camera_alt, size: 20),
            onPressed: () {
              // TODO: 카메라 페이지 이동
            },
          ),
        ],
      ),
    );
  }
}
