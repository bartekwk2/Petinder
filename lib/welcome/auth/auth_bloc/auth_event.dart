import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}
class PasswordInsertedEvent extends AuthEvent {
  final String password;
  PasswordInsertedEvent({this.password});
  @override
  List<Object> get props => [password];
}
class PasswordREInsertedEvent extends AuthEvent {
  final String password;
  PasswordREInsertedEvent({this.password});
  @override
  List<Object> get props => [password];
}

class EmailInsertedEvent extends AuthEvent {
  final String mail;
  EmailInsertedEvent({this.mail});
  @override
  List<Object> get props => [mail];
}

class DecideIfLoginEvent extends AuthEvent {
  final bool isLogin;
  DecideIfLoginEvent({this.isLogin});
  @override
  List<Object> get props => [isLogin];
}


class AuthClickedEvent extends AuthEvent {
}

class ErrorDialogClickedEvent extends AuthEvent{
}
