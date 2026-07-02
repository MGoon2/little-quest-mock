// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:little_quest/app/app.dart';
import 'package:little_quest/app/router/app_router.dart';
import 'package:little_quest/features/my_page/presentation/pages/my_page_screen.dart';
import 'package:little_quest/features/parent_mode/parent_mode_entry_page.dart';
import 'package:little_quest/features/profile_edit/presentation/pages/profile_edit_screen.dart';
import 'package:little_quest/features/signup/data/models/email_signup_form_state.dart';
import 'package:little_quest/features/signup/presentation/pages/email_signup_page.dart';
import 'package:little_quest/features/signup/presentation/pages/signup_method_page.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LittleQuestApp());

    // Verify that the welcome screen buttons are rendered.
    expect(find.text('퀘스트 시작하기'), findsOneWidget);
    expect(find.text('로그인'), findsOneWidget);
  });

  testWidgets('Quest start opens mode selection landing page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LittleQuestApp());

    await tester.tap(find.text('퀘스트 시작하기'));
    await tester.pumpAndSettle();

    expect(find.text('어떤 모드로 시작할까요?'), findsOneWidget);
    expect(find.text('아이 모드'), findsOneWidget);
    expect(find.text('부모 모드'), findsOneWidget);
  });

  testWidgets('Mode selection opens child and parent flows', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(initialRoute: '/mode-selection', routes: AppRouter.routes),
    );

    await tester.tap(find.text('부모 모드'));
    await tester.pumpAndSettle();

    expect(find.text('보호자 확인하기'), findsOneWidget);

    await tester.tap(find.byTooltip('뒤로가기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('아이 모드'));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 퀘스트'), findsOneWidget);
  });

  testWidgets('Signup method page opens email signup page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (context) => const SignupMethodPage(),
          '/signup/email': (context) => const EmailSignupPage(),
          '/login': (context) => const Scaffold(body: Text('Login')),
        },
      ),
    );

    expect(find.text('회원가입'), findsOneWidget);
    expect(find.text('이메일로 회원가입'), findsOneWidget);
    expect(find.text('Google로 계속하기'), findsOneWidget);
    expect(find.text('Apple로 계속하기'), findsOneWidget);
    expect(find.text('Naver로 계속하기'), findsOneWidget);
    expect(find.text('Kakao로 계속하기'), findsOneWidget);

    await tester.tap(find.text('이메일로 회원가입'));
    await tester.pumpAndSettle();

    expect(find.text('정보 입력'), findsOneWidget);
    expect(find.text('이메일을 입력해주세요'), findsOneWidget);
    expect(find.text('비밀번호를 다시 입력해주세요'), findsOneWidget);
  });

  testWidgets('Email signup renders required fields and starts disabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: EmailSignupPage()));

    ElevatedButton nextButton() {
      return tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '다음'),
      );
    }

    expect(nextButton().onPressed, isNull);
    expect(find.text('이메일을 입력해주세요'), findsOneWidget);
    expect(find.text('비밀번호를 입력해주세요'), findsOneWidget);
    expect(find.text('비밀번호를 다시 입력해주세요'), findsOneWidget);
    expect(find.text('이름을 입력해주세요'), findsOneWidget);
    expect(find.text('닉네임을 입력해주세요'), findsOneWidget);
    expect(find.byKey(const ValueKey('signup_birth_year')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup_birth_month')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup_birth_day')), findsOneWidget);
    expect(find.text('이용약관에 동의합니다. (필수)'), findsOneWidget);
    expect(find.text('개인정보 수집 및 이용에 동의합니다. (필수)'), findsOneWidget);
  });

  test(
    'Email signup form state is valid only when required data is complete',
    () {
      const empty = EmailSignupFormState();
      expect(empty.isValid, isFalse);

      const valid = EmailSignupFormState(
        email: 'child@example.com',
        password: 'Quest123!',
        passwordConfirm: 'Quest123!',
        name: '리틀',
        birthYear: 2018,
        birthMonth: 5,
        birthDay: 12,
        agreedTerms: true,
        agreedPrivacy: true,
      );

      expect(valid.isValid, isTrue);
    },
  );

  testWidgets('Parent mode entry verifies and opens parent home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(initialRoute: '/parent/entry', routes: AppRouter.routes),
    );

    expect(find.text('보호자 확인하기'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('보호자 확인하기'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('보호자 확인하기'));
    await tester.pumpAndSettle();

    expect(find.text('보호자 확인'), findsWidgets);
    expect(find.text('Google로 계속하기'), findsOneWidget);
    expect(find.text('Apple로 계속하기'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Quest123!');
    await tester.enterText(find.byType(TextField).at(1), 'Quest123!');
    await tester.pump();

    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, '확인'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, '확인'));
    await tester.pumpAndSettle();

    expect(find.text('이든이'), findsOneWidget);
    expect(find.text('개인정보 및 동의 관리'), findsOneWidget);
    expect(find.text('구독 및 결제 관리'), findsOneWidget);
  });

  final parentEntryNavigationCases = <String, String>{
    '개인정보 및 동의 관리': '동의 관리',
    '탐험 기록 및 위치 관리': '전체 요약',
    '구독 및 결제 관리': '현재 구독',
    '데이터 삭제 및 계정 관리': '데이터를 삭제하면 복구할 수 없어요.',
  };

  for (final entryCase in parentEntryNavigationCases.entries) {
    testWidgets('Parent mode entry opens ${entryCase.key}', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/parent/entry',
          routes: AppRouter.routes,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      );

      await tester.scrollUntilVisible(
        find.text(entryCase.key),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(entryCase.key));
      await tester.pumpAndSettle();

      expect(find.text(entryCase.value), findsWidgets);
    });
  }

  testWidgets('Parent home opens data management delete confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(initialRoute: '/parent/home', routes: AppRouter.routes),
    );

    await tester.scrollUntilVisible(
      find.text('데이터 관리'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('데이터 관리'));
    await tester.pumpAndSettle();

    expect(find.text('데이터를 삭제하면 복구할 수 없어요.'), findsOneWidget);
    expect(find.text('위치 기록 삭제'), findsOneWidget);

    await tester.tap(find.text('위치 기록 삭제'));
    await tester.pumpAndSettle();

    expect(find.text('정말 삭제할까요?'), findsOneWidget);
    expect(find.text('삭제한 데이터는 복구할 수 없어요.'), findsOneWidget);
  });

  final parentMenuNavigationCases = <String, String>{
    '개인정보 및 동의 관리': '개인정보',
    '탐험 기록 관리': '전체 요약',
    '위치 기록 관리': '장소/동 단위로 표시',
    '구독 및 결제 관리': '현재 구독',
    '알림 설정': '설정',
    '데이터 관리': '데이터를 삭제하면 복구할 수 없어요.',
  };

  for (final menuCase in parentMenuNavigationCases.entries) {
    testWidgets('Parent home menu opens ${menuCase.key}', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(initialRoute: '/parent/home', routes: AppRouter.routes),
      );

      await tester.scrollUntilVisible(
        find.text(menuCase.key),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(menuCase.key));
      await tester.pumpAndSettle();

      expect(find.text(menuCase.value), findsWidgets);
    });
  }

  testWidgets('Parent data delete actions always ask for confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(initialRoute: '/parent/data', routes: AppRouter.routes),
    );

    for (final label in [
      '사진 및 카드 삭제',
      '위치 기록 삭제',
      'AI 분석 데이터 삭제',
      '모든 데이터 삭제',
    ]) {
      await tester.scrollUntilVisible(
        find.text(label),
        220,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(find.text('정말 삭제할까요?'), findsOneWidget);
      expect(find.text('삭제하기'), findsOneWidget);

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
    }

    await tester.scrollUntilVisible(
      find.text('계정 삭제하기'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('계정 삭제하기'));
    await tester.pumpAndSettle();

    expect(find.text('계정 삭제는 보호자 확인이 필요해요.'), findsOneWidget);
    expect(find.text('보호자 확인 후 진행'), findsOneWidget);
  });

  final parentRouteSmokeCases = <String, String>{
    '/mode-selection': '어떤 모드로 시작할까요?',
    '/parent/entry': '보호자 확인하기',
    '/parent/verify': '보호자 확인',
    '/parent/home': '이든이',
    '/parent/children': '아이 목록',
    '/parent/children/child-1': '아이 정보',
    '/parent/guardian-info': '보호자 정보',
    '/parent/account-security': '계정 및 보안',
    '/parent/privacy-consent': '개인정보 및 동의 관리',
    '/parent/records': '탐험 기록 관리',
    '/parent/location': '위치 기록 관리',
    '/parent/subscription': '구독 및 결제 관리',
    '/parent/data': '데이터 관리',
    '/parent/settings': '설정',
  };

  for (final routeCase in parentRouteSmokeCases.entries) {
    testWidgets('Parent mode route ${routeCase.key} renders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: routeCase.key,
          routes: AppRouter.routes,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(routeCase.value), findsWidgets);
    });
  }

  testWidgets('Parent child list opens selected child info', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/parent/children',
        routes: AppRouter.routes,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );

    expect(find.text('아이 목록'), findsOneWidget);
    expect(find.text('현재 선택됨'), findsOneWidget);
    expect(find.text('아이 추가하기'), findsOneWidget);
    expect(find.text('서윤이'), findsOneWidget);
    expect(find.text('민준이'), findsOneWidget);

    await tester.tap(find.text('이든이'));
    await tester.pumpAndSettle();

    expect(find.text('아이 정보'), findsOneWidget);
    expect(find.text('탐험가 이든'), findsOneWidget);
    expect(find.text('레벨 12'), findsOneWidget);
    expect(find.text('정보 수정하기'), findsOneWidget);
  });

  testWidgets('Parent privacy rows open profile and security pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/parent/privacy-consent',
        routes: AppRouter.routes,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );

    await tester.tap(find.text('아이 정보'));
    await tester.pumpAndSettle();
    expect(find.text('아이 목록'), findsOneWidget);

    await tester.tap(find.byTooltip('뒤로가기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('보호자 정보'));
    await tester.pumpAndSettle();
    expect(find.text('보호자 연락처와 계정 정보를 관리할 수 있어요.'), findsOneWidget);

    await tester.tap(find.byTooltip('뒤로가기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('계정 및 보안'));
    await tester.pumpAndSettle();
    expect(find.text('모든 기기에서 로그아웃'), findsOneWidget);
  });

  testWidgets('Parent account security logout asks for confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/parent/account-security',
        routes: AppRouter.routes,
      ),
    );

    await tester.scrollUntilVisible(
      find.text('모든 기기에서 로그아웃'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('모든 기기에서 로그아웃'));
    await tester.pumpAndSettle();

    expect(find.text('모든 기기에서 로그아웃할까요?'), findsOneWidget);
    expect(find.text('현재 사용 중인 기기를 제외한 모든 기기에서 다시 로그인이 필요해요.'), findsOneWidget);
    expect(find.text('로그아웃'), findsOneWidget);
  });

  testWidgets('My page exposes parent mode entrypoint', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {'/parent/entry': (context) => const ParentModeEntryPage()},
        home: const MyPageScreen(),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('보호자 모드로 이동'),
      500,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('보호자 모드'), findsOneWidget);
    expect(find.text('보호자 모드로 이동'), findsOneWidget);

    await tester.tap(find.text('보호자 모드로 이동'));
    await tester.pumpAndSettle();

    expect(find.text('보호자 확인하기'), findsOneWidget);
  });

  testWidgets('Child profile edit does not expose direct account deletion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileEditScreen()));

    expect(find.text('계정 삭제'), findsNothing);
    expect(find.text('구독 및 결제 관리'), findsNothing);
    expect(AppRouter.routes.containsKey('/plan'), isFalse);
  });
}
