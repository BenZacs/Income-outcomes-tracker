import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';
import 'package:income_expense_tracker/src/pages/home_page/home_page.dart';

part 'register_page_state.dart';
part 'register_page_event.dart';

typedef _Event = RegisterPageEvent;
typedef _State = RegisterPageState;

class RegisterPageBloc extends Bloc<_Event, _State> {
  RegisterPageBloc({
    required this.dialogCubit,
    required this.routerCubit,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadSuccededEvent>(_onLoadSucceeded);
    on<RegisterRequestedEvent>(_onRegisterRequested);
    on<RegisterSucceededEvent>(_onRegisterSucceeded);
    on<RegisterFailedEvent>(_onRegisterFailed);
  }

  final RouterCubit routerCubit;
  final DialogCubit dialogCubit;

  void _onStarted(
    StartedEvent event,
    Emitter<_State> emit,
  ) async {
    add(LoadSuccededEvent());
  }

  void _onLoadSucceeded(
    LoadSuccededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState());
  }

  void _onRegisterRequested(
    RegisterRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(RegisterRequestingState());

    Timer(Duration(seconds: 1),
        () => add(RegisterSucceededEvent(username: event.username)));
  }

  void _onRegisterSucceeded(
    RegisterSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(this.state);

    routerCubit.pushReplacement(page: HomePage(username: event.username));
  }

  void _onRegisterFailed(
    RegisterFailedEvent event,
    Emitter<_State> emit,
  ) async {
    final errorMessage = event.error;

    dialogCubit.show(title: "Register Failed", content: errorMessage);

    emit(LoadSuccessState());
  }
}
