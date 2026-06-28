/// 계정 확인 Repository 인터페이스.
///
/// 개인정보 수정 진입 전 재인증을 처리한다.
/// 이메일/비밀번호 가입자는 비밀번호 입력으로 본인 확인을 진행한다.
/// 재인증 성공 후 10분 동안 개인정보 수정이 허용되며, 서버에서 재인증 상태를 검증해야 한다.
abstract class AccountVerificationRepository {
  Future<bool> verifyPassword(String password);
}

/// 개발/테스트용 mock repository.
///
/// 실제 서비스에서는 클라이언트만 믿지 않고 서버에서 비밀번호 재확인 후
/// reauthenticated_at 또는 reauth token을 발급해야 한다.
class MockAccountVerificationRepository implements AccountVerificationRepository {
  const MockAccountVerificationRepository();

  @override
  Future<bool> verifyPassword(String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return password.isNotEmpty;
  }
}
