part of 'authentication_cubit.dart';

abstract class AuthenticationCubitState {}

class NotAuthenticated extends _State {}

class Authenticated extends _State {
  Authenticated(this.username, this.password);

  final String username;
  final String password;
}
