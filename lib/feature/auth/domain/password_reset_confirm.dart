class PasswordResetConfirm {
  const PasswordResetConfirm({
    required this.email,
    required this.code,
    required this.password,
  });

  final String email;
  final String code;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
        'password': password,
      };
}
