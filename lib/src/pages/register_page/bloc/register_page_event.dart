part of 'register_page_bloc.dart';

abstract class RegisterPageEvent {}

class StartedEvent extends _Event {}

class LoadSuccededEvent extends _Event {}

class RegisterRequestedEvent extends _Event {
  RegisterRequestedEvent(
    this.username,
    this.password,
  );

  final String username;
  final String password;
}

class RegisterSucceededEvent extends _Event {
  RegisterSucceededEvent({required this.username});

  final String username;
}

class RegisterFailedEvent extends _Event {
  RegisterFailedEvent(this.error);

  final String error;
}
