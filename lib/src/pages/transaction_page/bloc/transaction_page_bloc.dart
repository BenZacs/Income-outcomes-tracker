import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:income_expense_tracker/src/models/Transaction.dart';

part 'transaction_page_state.dart';
part 'transaction_page_event.dart';

typedef _Event = TransactionPageEvent;
typedef _State = TransactionPageState;

class TransactionPageBloc extends Bloc<_Event, _State> {
  TransactionPageBloc({required this.transactions}) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadSuccededEvent>(_onLoadSucceeded);
  }

  final List<Transaction> transactions;

  void _onStarted(
    StartedEvent event,
    Emitter<_State> emit,
  ) async {
    add(LoadSuccededEvent(transactions: transactions));
  }

  void _onLoadSucceeded(
    LoadSuccededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState(
      transactions: event.transactions,
    ));
  }
}
