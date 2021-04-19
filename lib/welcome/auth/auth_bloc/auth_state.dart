
class AuthState {
  String email;
  String password;
  String passwordRE;
  bool isCorrect;
  bool errorLogin;
  String id;
  String error;
  bool isLogin;

  AuthState(
      {this.email,
      this.password,
      this.isCorrect,
      this.errorLogin,
      this.id,
      this.error,
      this.isLogin,
      this.passwordRE});

  factory AuthState.empty() {
    return AuthState(
        email: "",
        password: "",
        passwordRE: "",
        isLogin: false,
        error: "",
        isCorrect: false,
        id: "",
        errorLogin: false);
  }

  AuthState copyWith({
    String email,
    String error,
    String password,
    bool isLogin,
    String passwordRE,
    bool passwordsSame,
    bool isCorrect,
    bool errorLogin,
    String id,
  }) {
    return AuthState(
      error: error ?? this.error,
      email: email ?? this.email,
      isLogin: isLogin ?? this.isLogin,
      password: password ?? this.password,
      passwordRE: passwordRE ?? this.passwordRE,
      isCorrect: isCorrect ?? this.isCorrect,
      errorLogin: errorLogin ?? this.errorLogin,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'passwordRE': passwordRE,
      'isCorrect': isCorrect,
      'errorLogin': errorLogin,
      'id': id,
      'error': error,
      'isLogin': isLogin,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      email:map['email'],
      password:map['password'],
      passwordRE:map['passwordRE'],
      isCorrect:map['isCorrect'],
      errorLogin:map['errorLogin'],
      id:map['id'],
      error:map['error'],
      isLogin:map['isLogin'],
    );
  }

}
