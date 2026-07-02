import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/parent_mode/models/parent_child_summary.dart';
import 'package:little_quest/features/parent_mode/models/parent_consent_status.dart';
import 'package:little_quest/features/parent_mode/models/parent_menu_item.dart';
import 'package:little_quest/features/parent_mode/models/parent_record_summary.dart';
import 'package:little_quest/features/parent_mode/models/parent_subscription_summary.dart';

/// 부모 모드 UI 확인용 fixture 데이터.
///
/// 실제 서비스에서는 각 TODO 위치에서 보호자/아이 데이터 API로 대체한다.
abstract final class ParentModeFixture {
  static const childSummary = ParentChildSummary(
    childName: '이든이',
    age: 7,
    explorerLevel: 12,
    avatarAssetPath:
        'assets/images/account_verification/explorer_verification_header.png',
  );

  static const recordSummary = ParentRecordSummary(
    photoCount: 128,
    cardCount: 86,
    placeCount: 24,
  );

  static final subscriptionSummary = ParentSubscriptionSummary(
    planName: 'Little Quest Plus',
    active: true,
    billingCycleLabel: '월간 구독',
    nextBillingDate: DateTime(2024, 6, 20),
  );

  static const menuItems = [
    ParentMenuItem(
      title: '개인정보 및 동의 관리',
      description: '아이 정보와 동의 상태',
      icon: Icons.verified_user_outlined,
      type: ParentMenuType.privacyConsent,
    ),
    ParentMenuItem(
      title: '탐험 기록 관리',
      description: '사진, 카드, 퀘스트',
      icon: Icons.local_florist_outlined,
      type: ParentMenuType.discoveryRecord,
    ),
    ParentMenuItem(
      title: '위치 기록 관리',
      description: '장소 수준 기록 확인',
      icon: Icons.location_on_outlined,
      type: ParentMenuType.locationRecord,
    ),
    ParentMenuItem(
      title: '구독 및 결제 관리',
      description: '플랜과 결제 수단',
      icon: Icons.credit_card_outlined,
      type: ParentMenuType.subscription,
    ),
    ParentMenuItem(
      title: '알림 설정',
      description: '푸시와 소식 알림',
      icon: Icons.notifications_none,
      type: ParentMenuType.notification,
    ),
    ParentMenuItem(
      title: '데이터 관리',
      description: '삭제와 계정 관리',
      icon: Icons.delete_outline,
      type: ParentMenuType.dataManagement,
    ),
  ];

  static const privacySections = [
    ParentInfoSection(
      title: '개인정보',
      items: [
        ParentInfoItem(
          title: '아이 정보',
          description: '이름, 생년월일, 성별 등',
          icon: Icons.child_care,
          routeName: '/parent/children',
        ),
        ParentInfoItem(
          title: '보호자 정보',
          description: '이메일, 연락처',
          icon: Icons.person_outline,
          routeName: '/parent/guardian-info',
        ),
        ParentInfoItem(
          title: '계정 및 보안',
          description: '비밀번호 변경, 2단계 인증',
          icon: Icons.security_outlined,
          routeName: '/parent/account-security',
        ),
      ],
    ),
  ];

  static const consentStatuses = [
    ParentConsentStatus(
      title: '개인정보 수집 및 이용',
      description: '서비스 제공을 위한 필수 정보',
      isRequired: true,
      agreed: true,
    ),
    ParentConsentStatus(
      title: '사진 업로드 및 AI 분석',
      description: '자연 사진 분석과 카드 생성',
      isRequired: true,
      agreed: true,
    ),
    ParentConsentStatus(
      title: '위치정보 수집 및 이용',
      description: '장소/동 단위 탐험 기록',
      isRequired: false,
      agreed: true,
    ),
    ParentConsentStatus(
      title: '푸시 알림 수신',
      description: '탐험 리마인드와 가족 알림',
      isRequired: false,
      agreed: false,
    ),
  ];

  static const recentPhotos = [
    ParentRecentPhoto(
      label: '데이지',
      color: Color(0xFFE9F4C9),
      icon: Icons.local_florist,
    ),
    ParentRecentPhoto(
      label: '나비',
      color: Color(0xFFFFF0B8),
      icon: Icons.flutter_dash,
    ),
    ParentRecentPhoto(label: '은행잎', color: Color(0xFFE6F3D1), icon: Icons.park),
    ParentRecentPhoto(label: '강가', color: Color(0xFFDDEFF0), icon: Icons.water),
    ParentRecentPhoto(label: '노란 꽃', color: Color(0xFFFFEBA8), icon: Icons.spa),
    ParentRecentPhoto(label: '초록 잎', color: Color(0xFFD9EFD0), icon: Icons.eco),
  ];

  static const locationPins = [
    ParentLocationPin(dx: 0.18, dy: 0.58, label: '강변공원'),
    ParentLocationPin(dx: 0.34, dy: 0.32, label: '숲길 입구'),
    ParentLocationPin(dx: 0.58, dy: 0.48, label: '생태정원'),
    ParentLocationPin(dx: 0.78, dy: 0.26, label: '산책로'),
    ParentLocationPin(dx: 0.70, dy: 0.64, label: '꽃밭'),
  ];

  static const subscriptionBenefits = [
    ParentBenefit(label: '무제한 카드 생성', icon: Icons.check_circle),
    ParentBenefit(label: '탐험 지도 무제한 저장', icon: Icons.check_circle),
    ParentBenefit(label: 'AI 리포트 다운로드', icon: Icons.check_circle),
    ParentBenefit(label: '광고 없이 이용', icon: Icons.check_circle),
  ];

  static const deletionOptions = [
    ParentDeletionOption(
      title: '사진 및 카드 삭제',
      description: '업로드한 사진과 생성한 카드 삭제',
      icon: Icons.photo_library_outlined,
    ),
    ParentDeletionOption(
      title: '위치 기록 삭제',
      description: '지도에 기록된 위치 정보 삭제',
      icon: Icons.location_on_outlined,
    ),
    ParentDeletionOption(
      title: 'AI 분석 데이터 삭제',
      description: 'AI 분석을 위해 사용된 데이터 삭제',
      icon: Icons.psychology_alt_outlined,
    ),
    ParentDeletionOption(
      title: '모든 데이터 삭제',
      description: '앱에 저장된 모든 데이터 삭제',
      icon: Icons.delete_sweep_outlined,
      destructive: true,
    ),
  ];

  static const generalSettings = [
    ParentSettingsRow(title: '언어 설정', value: '한국어', icon: Icons.language),
    ParentSettingsRow(
      title: '앱 정보',
      value: '버전 1.0.0',
      icon: Icons.info_outline,
    ),
  ];

  static const supportSettings = [
    ParentSettingsRow(title: '도움말 및 문의', icon: Icons.help_outline),
    ParentSettingsRow(title: '자주 묻는 질문', icon: Icons.question_answer_outlined),
  ];
}

class ParentInfoSection {
  final String title;
  final List<ParentInfoItem> items;

  const ParentInfoSection({required this.title, required this.items});
}

class ParentInfoItem {
  final String title;
  final String description;
  final IconData icon;
  final String? routeName;

  const ParentInfoItem({
    required this.title,
    required this.description,
    required this.icon,
    this.routeName,
  });
}

class ParentRecentPhoto {
  final String label;
  final Color color;
  final IconData icon;

  const ParentRecentPhoto({
    required this.label,
    required this.color,
    required this.icon,
  });
}

class ParentLocationPin {
  final double dx;
  final double dy;
  final String label;

  const ParentLocationPin({
    required this.dx,
    required this.dy,
    required this.label,
  });
}

class ParentBenefit {
  final String label;
  final IconData icon;

  const ParentBenefit({required this.label, required this.icon});
}

class ParentDeletionOption {
  final String title;
  final String description;
  final IconData icon;
  final bool destructive;

  const ParentDeletionOption({
    required this.title,
    required this.description,
    required this.icon,
    this.destructive = false,
  });
}

class ParentSettingsRow {
  final String title;
  final String? value;
  final IconData icon;

  const ParentSettingsRow({
    required this.title,
    required this.icon,
    this.value,
  });
}

extension ParentSubscriptionSummaryX on ParentSubscriptionSummary {
  String get statusLabel => active ? '활성' : '비활성';

  String get nextBillingDateLabel {
    final date = nextBillingDate;
    if (date == null) return '등록된 결제일 없음';

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }
}

extension ParentConsentStatusX on ParentConsentStatus {
  String get agreementLabel => agreed ? '동의함' : '미동의';

  String get requirementLabel => isRequired ? '필수' : '선택';

  Color get badgeColor => agreed ? LqColors.softGreen : const Color(0xFFF1F0E8);

  Color get textColor => agreed ? LqColors.deepGreen : LqColors.textSubtle;
}
