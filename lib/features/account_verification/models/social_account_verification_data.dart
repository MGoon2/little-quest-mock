/// SNS 인증 제공자.
enum AuthProvider {
  google,
  apple,
  naver,
  kakao,
}

/// SNS 계정 확인 데이터.
class SocialAccountVerificationData {
  final List<AuthProvider> providers;
  final int reauthenticationValidMinutes;

  const SocialAccountVerificationData({
    required this.providers,
    this.reauthenticationValidMinutes = 10,
  });
}
