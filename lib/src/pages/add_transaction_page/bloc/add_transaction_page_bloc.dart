import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';
import 'package:income_expense_tracker/src/models/Transaction.dart';

part 'add_transaction_page_state.dart';
part 'add_transaction_page_event.dart';

typedef _Event = AddTransactionPageEvent;
typedef _State = AddTransactionPageState;

class AddTransactionPageBloc extends Bloc<_Event, _State> {
  AddTransactionPageBloc({
    required this.dialogCubit,
    required this.routerCubit,
    required this.transactionsCollection,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadSuccededEvent>(_onLoadSucceeded);
    on<AddTransactionRequestedEvent>(_onAddTransactionRequested);
    on<AddTransactionSucceededEvent>(_onAddTransactionSucceeded);
    on<AddTransactionFailedEvent>(_onAddTransactionFailed);
  }

  final DialogCubit dialogCubit;
  final RouterCubit routerCubit;
  final CollectionReference transactionsCollection;

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

  void _onAddTransactionRequested(
    AddTransactionRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(AddTransactionRequestingState());

    try {
      await transactionsCollection.add(event.transaction);

      add(AddTransactionSucceededEvent());
    } catch (error) {
      AddTransactionFailedEvent(error: "$error");
    }
  }

  void _onAddTransactionSucceeded(
    AddTransactionSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState());

    dialogCubit.show(title: "Transaction Added", content: "");
  }

  void _onAddTransactionFailed(
    AddTransactionFailedEvent event,
    Emitter<_State> emit,
  ) async {
    final errorMessage = event.error;

    dialogCubit.show(title: "AddTransaction Failed", content: errorMessage);

    emit(LoadSuccessState());
  }
}
