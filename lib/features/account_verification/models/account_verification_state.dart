/// 계정 확인 유형.
enum AccountVerificationType {
  password,
  social,
  multiple,
}

/// 계정 확인 상태.
class AccountVerificationState {
  final AccountVerificationType type;
  final bool isSubmitting;
  final String? errorMessage;

  const AccountVerificationState({
    this.type = AccountVerificationType.password,
    this.isSubmitting = false,
    this.errorMessage,
  });

  AccountVerificationState copyWith({
    AccountVerificationType? type,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return AccountVerificationState(
      type: type ?? this.type,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}
