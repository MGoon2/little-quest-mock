import 'package:flutter/material.dart';

import 'package:little_quest/features/my_page/data/datasources/my_page_fixture.dart';
import 'package:little_quest/features/my_page/data/models/my_page_data.dart';
import 'package:little_quest/features/my_page/presentation/widgets/activity_shortcut_stats.dart';
import 'package:little_quest/features/my_page/presentation/widgets/explorer_header_illustration.dart';
import 'package:little_quest/features/my_page/presentation/widgets/my_badges_section.dart';
import 'package:little_quest/features/my_page/presentation/widgets/my_page_app_bar.dart';
import 'package:little_quest/features/my_page/presentation/widgets/my_page_bottom_cta_card.dart';
import 'package:little_quest/features/my_page/presentation/widgets/profile_level_summary_card.dart';
import 'package:little_quest/features/my_page/presentation/widgets/recent_observation_section.dart';
import 'package:little_quest/features/my_page/presentation/widgets/weekly_exploration_summary_card.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

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
