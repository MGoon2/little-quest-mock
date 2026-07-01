// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:little_quest/app/app.dart';
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
}
