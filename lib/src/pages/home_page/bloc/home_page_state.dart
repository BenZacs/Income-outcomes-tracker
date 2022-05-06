part of 'home_page_bloc.dart';

abstract class HomePageState {}

class InitialState extends _State {}

class LoadingState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.totalIncome,
    required this.totalExpense,
    required this.summary,
    required this.transactions,
  });

  final double totalIncome;
  final double totalExpense;
  final double summary;
  final List<Transaction> transactions;
}

class LoadFailureState extends _State {
  LoadFailureState({required this.error});

  final String error;
}
