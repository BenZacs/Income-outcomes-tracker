part of 'home_page_bloc.dart';

abstract class HomePageEvent {}

class StartedEvent extends _Event {}

class LoadRequestedEvent extends _Event {}

class LoadSuccededEvent extends _Event {
  LoadSuccededEvent({
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

class LoadFailedEvent extends _Event {
  LoadFailedEvent(this.error);

  final String error;
}
