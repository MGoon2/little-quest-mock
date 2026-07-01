import 'package:flutter/material.dart';
import 'package:little_quest/app/theme/app_colors.dart';

/// 발견 카드의 카테고리.
enum DiscoveryCategory { all, plant, animal, insect, building }

extension DiscoveryCategoryX on DiscoveryCategory {
  String get label {
    switch (this) {
      case DiscoveryCategory.all:
        return '전체';
      case DiscoveryCategory.plant:
        return '식물';
      case DiscoveryCategory.animal:
        return '동물';
      case DiscoveryCategory.insect:
        return '곤충';
      case DiscoveryCategory.building:
        return '건물';
    }
  }

  IconData get icon {
    switch (this) {
      case DiscoveryCategory.all:
        return Icons.grid_view;
      case DiscoveryCategory.plant:
        return Icons.eco;
      case DiscoveryCategory.animal:
        return Icons.pets;
      case DiscoveryCategory.insect:
        return Icons.bug_report;
      case DiscoveryCategory.building:
        return Icons.account_balance;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case DiscoveryCategory.all:
        return AppColors.primarySoft;
      case DiscoveryCategory.plant:
        return AppColors.leafLight;
      case DiscoveryCategory.animal:
        return AppColors.pawLight;
      case DiscoveryCategory.insect:
        return AppColors.accentYellowLight;
      case DiscoveryCategory.building:
        return AppColors.flowerLight;
    }
  }

  String get summaryTitle {
    switch (this) {
      case DiscoveryCategory.all:
        return '오늘까지 32장의 발견 카드를 모았어요!';
      case DiscoveryCategory.plant:
        return '식물 카드를 12장 모았어요';
      case DiscoveryCategory.animal:
        return '동물 카드를 5장 모았어요';
      case DiscoveryCategory.insect:
        return '곤충 카드를 3장 모았어요';
      case DiscoveryCategory.building:
        return '건물 카드를 8장 모았어요';
    }
  }

  String get summarySubtitle {
    switch (this) {
      case DiscoveryCategory.all:
        return '이번 주에는 5장을 발견했어요.';
      case DiscoveryCategory.plant:
        return '초록 친구들과 함께 자연을 더 가까이 알아가요.';
      case DiscoveryCategory.animal:
        return '움직이는 친구들과 함께 탐험을 이어가요.';
      case DiscoveryCategory.insect:
        return '작고 신기한 친구들을 관찰해보세요.';
      case DiscoveryCategory.building:
        return '장소와 이야기를 담은 기록을 남겨요.';
    }
  }

  String get sectionTitle {
    switch (this) {
      case DiscoveryCategory.all:
        return '';
      case DiscoveryCategory.plant:
        return '식물 12장';
      case DiscoveryCategory.animal:
        return '동물 5장';
      case DiscoveryCategory.insect:
        return '곤충 3장';
      case DiscoveryCategory.building:
        return '건물 8장';
    }
  }

  String get sectionDescription {
    switch (this) {
      case DiscoveryCategory.all:
        return '';
      case DiscoveryCategory.plant:
        return '초록 친구들을 모았어요.';
      case DiscoveryCategory.animal:
        return '움직이는 친구들을 발견했어요.';
      case DiscoveryCategory.insect:
        return '작고 신기한 친구들이에요.';
      case DiscoveryCategory.building:
        return '장소와 이야기를 담았어요.';
    }
  }
}
