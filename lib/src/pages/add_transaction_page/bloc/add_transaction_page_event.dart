part of 'add_transaction_page_bloc.dart';

abstract class AddTransactionPageEvent {}

class StartedEvent extends _Event {}

class LoadSuccededEvent extends _Event {}

class AddTransactionRequestedEvent extends _Event {
  AddTransactionRequestedEvent({required this.transaction});

  final Transaction transaction;
}

class AddTransactionSucceededEvent extends _Event {
  AddTransactionSucceededEvent();
}

class AddTransactionFailedEvent extends _Event {
  AddTransactionFailedEvent({required this.error});

  final String error;
}

class RegisterRequestedEvent extends _Event {}
