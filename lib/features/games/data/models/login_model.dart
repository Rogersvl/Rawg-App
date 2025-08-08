class LoginModel {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;

  LoginModel({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
  });

  LoginModel copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
    );
  }
}
