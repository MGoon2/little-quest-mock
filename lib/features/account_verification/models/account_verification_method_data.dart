/// 계정 확인 방법.
enum VerificationMethod {
  password,
  google,
  apple,
  naver,
  kakao,
}

/// 계정 확인 방법 선택 데이터.
class AccountVerificationMethodData {
  final List<VerificationMethod> methods;
  final int reauthenticationValidMinutes;

  const AccountVerificationMethodData({
    required this.methods,
    this.reauthenticationValidMinutes = 10,
  });
}
