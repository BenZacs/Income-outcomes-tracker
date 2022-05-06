part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class StartedEvent extends _Event {}

class LoadSuccededEvent extends _Event {}

class LoginRequestedEvent extends _Event {
  LoginRequestedEvent(
    this.username,
    this.password,
  );

  final String username;
  final String password;
}

class LoginSucceededEvent extends _Event {
  LoginSucceededEvent({required this.username});

  final String username;
}

class LoginFailedEvent extends _Event {
  LoginFailedEvent(this.error);

  final String error;
}

class RegisterRequestedEvent extends _Event {}
