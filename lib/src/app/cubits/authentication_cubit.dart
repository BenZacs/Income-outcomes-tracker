import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_cubit_state.dart';

typedef _State = AuthenticationCubitState;

class AuthenticationCubit extends Cubit<_State> {
  AuthenticationCubit() : super(NotAuthenticated());

  void login(String username, String password) {
    emit(Authenticated(username, password));
  }

  void logout() {
    emit(NotAuthenticated());
  }
}
