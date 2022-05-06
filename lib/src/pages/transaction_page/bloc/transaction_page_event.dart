part of 'transaction_page_bloc.dart';

abstract class TransactionPageEvent {}

class StartedEvent extends _Event {}

class LoadSuccededEvent extends _Event {
  LoadSuccededEvent({
    required this.transactions,
  });

  final List<Transaction> transactions;
}
