part of 'router_cubit.dart';

abstract class RouterCubitState {}

class PushState extends _State {
  PushState({
    required this.page,
    required this.onNavigated,
  });

  final Widget page;
  final Function onNavigated;
}

class PushReplacementState extends _State {
  PushReplacementState({
    required this.page,
    required this.onNavigated,
  });

  final Widget page;
  final Function onNavigated;
}

class PopState extends _State {
  PopState({required this.onNavigated});

  final Function onNavigated;
}
