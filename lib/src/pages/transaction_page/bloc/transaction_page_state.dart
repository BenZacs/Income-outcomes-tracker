part of 'transaction_page_bloc.dart';

abstract class TransactionPageState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.transactions,
  });

  final List<Transaction> transactions;
}
