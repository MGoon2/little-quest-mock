class EmailSignupFormState {
  final String email;
  final String password;
  final String passwordConfirm;
  final String name;
  final String? nickname;
  final int? birthYear;
  final int? birthMonth;
  final int? birthDay;
  final bool agreedTerms;
  final bool agreedPrivacy;

  const EmailSignupFormState({
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.name = '',
    this.nickname,
    this.birthYear,
    this.birthMonth,
    this.birthDay,
    this.agreedTerms = false,
    this.agreedPrivacy = false,
  });

  bool get isEmailValid {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailPattern.hasMatch(email.trim());
  }

  bool get isPasswordValid {
    final value = password.trim();
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\];`~+=]',
    ).hasMatch(value);
    return value.length >= 8 && hasLetter && hasNumber && hasSpecial;
  }

  bool get isPasswordConfirmValid {
    return passwordConfirm.isNotEmpty && passwordConfirm == password;
  }

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isBirthDateValid {
    return birthYear != null && birthMonth != null && birthDay != null;
  }

  bool get isRequiredAgreementValid => agreedTerms && agreedPrivacy;

  bool get isValid {
    return isEmailValid &&
        isPasswordValid &&
        isPasswordConfirmValid &&
        isNameValid &&
        isBirthDateValid &&
        isRequiredAgreementValid;
  }

  EmailSignupFormState copyWith({
    String? email,
    String? password,
    String? passwordConfirm,
    String? name,
    String? nickname,
    int? birthYear,
    int? birthMonth,
    int? birthDay,
    bool? agreedTerms,
    bool? agreedPrivacy,
  }) {
    return EmailSignupFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      birthYear: birthYear ?? this.birthYear,
      birthMonth: birthMonth ?? this.birthMonth,
      birthDay: birthDay ?? this.birthDay,
      agreedTerms: agreedTerms ?? this.agreedTerms,
      agreedPrivacy: agreedPrivacy ?? this.agreedPrivacy,
    );
  }
}
