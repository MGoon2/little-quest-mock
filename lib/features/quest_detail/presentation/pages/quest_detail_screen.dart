import 'package:flutter/material.dart';

import 'package:little_quest/features/quest_detail/data/datasources/quest_detail_fixture.dart';
import 'package:little_quest/features/quest_detail/data/models/quest_detail_data.dart';
import 'package:little_quest/features/quest_detail/presentation/widgets/quest_detail_app_bar.dart';
import 'package:little_quest/features/quest_detail/presentation/widgets/quest_hero_card.dart';
import 'package:little_quest/features/quest_detail/presentation/widgets/quest_mission_card.dart';
import 'package:little_quest/features/quest_detail/presentation/widgets/quest_progress_card.dart';
import 'package:little_quest/features/quest_detail/presentation/widgets/quest_reward_notice.dart';
import 'package:little_quest/features/quest_detail/presentation/widgets/required_quest_items_section.dart';
import 'package:little_quest/app/theme/lq_colors.dart';

/// 퀘스트 상세 페이지.
class QuestDetailScreen extends StatelessWidget {
  final QuestDetailData? quest;

  const QuestDetailScreen({super.key, this.quest});

  @override
  Widget build(BuildContext context) {
    final data = quest ?? QuestDetailFixture.springPlants;

    return Scaffold(
      backgroundColor: LqColors.cream,
      appBar: const QuestDetailAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestHeroCard(quest: data),
              const SizedBox(height: 24),
              QuestProgressCard(quest: data),
              const SizedBox(height: 24),
              RequiredQuestItemsSection(
                items: data.targetItems,
                onSeeAll: () {
                  // TODO: quest target list page
                },
              ),
              const SizedBox(height: 24),
              QuestMissionCard(missions: data.missions),
              const SizedBox(height: 16),
              const QuestRewardNotice(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
