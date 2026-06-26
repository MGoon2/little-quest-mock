import 'package:flutter/material.dart';

import '../features/my_page/data/my_page_fixture.dart';
import '../features/my_page/models/my_page_data.dart';
import '../features/my_page/widgets/activity_shortcut_stats.dart';
import '../features/my_page/widgets/explorer_header_illustration.dart';
import '../features/my_page/widgets/my_badges_section.dart';
import '../features/my_page/widgets/my_page_app_bar.dart';
import '../features/my_page/widgets/my_page_bottom_cta_card.dart';
import '../features/my_page/widgets/profile_level_summary_card.dart';
import '../features/my_page/widgets/recent_observation_section.dart';
import '../features/my_page/widgets/weekly_exploration_summary_card.dart';
import '../theme/lq_colors.dart';

/// 마이페이지 화면.
class MyPageScreen extends StatelessWidget {
  final MyPageData? data;

  const MyPageScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final myPageData = data ?? MyPageFixture.sample;

    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const MyPageAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExplorerHeaderIllustration(),
              Transform.translate(
                offset: const Offset(0, -32),
                child: ProfileLevelSummaryCard(data: myPageData),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: ActivityShortcutStats(
                  data: myPageData,
                  onCards: () {
                    // TODO: discovery card list page
                  },
                  onObservations: () {
                    // TODO: observation history page
                  },
                  onQuests: () {
                    // TODO: quest list page
                  },
                  onLikes: () {
                    // TODO: favorite cards page
                  },
                ),
              ),
              WeeklyExplorationSummaryCard(data: myPageData),
              const SizedBox(height: 18),
              RecentObservationSection(
                observations: myPageData.recentObservations,
                onSeeAll: () {
                  // TODO: observation list page
                },
              ),
              const SizedBox(height: 18),
              MyBadgesSection(
                badges: myPageData.badges,
                onSeeAll: () {
                  // TODO: badge list page
                },
              ),
              const SizedBox(height: 18),
              MyPageBottomCtaCard(
                onTap: () {
                  // TODO: camera or exploration page
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
