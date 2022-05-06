import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';

import 'package:income_expense_tracker/src/models/Transaction.dart';

part 'home_page_state.dart';
part 'home_page_event.dart';

typedef _Event = HomePageEvent;
typedef _State = HomePageState;

class HomePageBloc extends Bloc<_Event, _State> {
  HomePageBloc({
    required this.dialogCubit,
    required this.routerCubit,
    required this.transactionsCollection,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadRequestedEvent>(_onLoadRequested);
    on<LoadSuccededEvent>(_onLoadSucceeded);
    on<LoadFailedEvent>(_onLoadFailed);
  }

  final DialogCubit dialogCubit;
  final RouterCubit routerCubit;
  final CollectionReference<Transaction> transactionsCollection;

  void _onStarted(
    StartedEvent event,
    Emitter<_State> emit,
  ) async {
    add(LoadRequestedEvent());
  }

  void _onLoadRequested(
    LoadRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    _loadData();

    emit(LoadingState());
  }

  Future<void> _loadData() async {
    try {
      final transactions = await _loadTransactions();

      final totalIncome = _totalIncome(transactions);
      final totalExpense = _totalExpense(transactions);
      final summary = totalIncome - totalExpense;

      add(LoadSuccededEvent(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        summary: summary,
        transactions: transactions,
      ));
    } catch (error) {
      add(LoadFailedEvent("$error"));
    }
  }

  Future<List<Transaction>> _loadTransactions() async {
    QuerySnapshot<Transaction> querySnapshot =
        await transactionsCollection.get();

    final transactions = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(transactions);
    return transactions;
  }

  double _totalExpense(List<Transaction> transactions) {
    final expenseTransactions =
        transactions.where((element) => element.type == "Expense").toList();

    return expenseTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  double _totalIncome(List<Transaction> transactions) {
    final incomeTransactions =
        transactions.where((element) => element.type == "Income").toList();

    return incomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  void _onLoadSucceeded(
    LoadSuccededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState(
      totalIncome: event.totalIncome,
      totalExpense: event.totalExpense,
      summary: event.summary,
      transactions: event.transactions,
    ));
  }

  void _onLoadFailed(
    LoadFailedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadFailureState(error: event.error));
  }
}
