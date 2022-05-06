import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';

import 'package:income_expense_tracker/src/common/widgets/app_page.dart';
import 'package:income_expense_tracker/src/common/widgets/loading_indicator.dart';
import 'package:income_expense_tracker/src/pages/add_transaction_page/add_transaction_page.dart';
import 'package:income_expense_tracker/src/pages/login_page/login_page.dart';
import 'package:income_expense_tracker/src/pages/transaction_page/transaction_page.dart';

import '../../models/Transaction.dart';
import 'bloc/home_page_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({required this.username}) : super();

  final String username;

  final CollectionReference<Transaction> transactionsCollection =
      FirebaseFirestore.instance
          .collection('transactions')
          .withConverter<Transaction>(
            fromFirestore: (snapshot, _) =>
                Transaction.fromJson(snapshot.data()!),
            toFirestore: (transaction, _) => transaction.toJson(),
          );

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: _title(context),
      content: _content(context),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTransactionPage()));
          },
        ),
      ],
    );
  }

  String _title(BuildContext context) {
    return "Account Summary";
  }

  Widget _content(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc(
        dialogCubit: context.read<DialogCubit>(),
        routerCubit: context.read<RouterCubit>(),
        transactionsCollection: transactionsCollection,
      ),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          return _mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget _mapStateToContent(
    BuildContext context,
    HomePageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return _initialContent(context, state as InitialState);
      case LoadingState:
        return _loadingContent(context, state as LoadingState);
      case LoadSuccessState:
        return _loadSuccessContent(context, state as LoadSuccessState);
      case LoadFailureState:
        return _loadFailureContent(context, state as LoadFailureState);
      default:
        throw new Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget _initialContent(
    BuildContext context,
    HomePageState state,
  ) {
    context.read<HomePageBloc>().add(StartedEvent());

    return Container();
  }

  Widget _loadingContent(
    BuildContext context,
    LoadingState state,
  ) {
    return LoadingIndicator();
  }

  Widget _loadSuccessContent(
    BuildContext context,
    LoadSuccessState state,
  ) {
    final bloc = context.read<HomePageBloc>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black38,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              showAdaptiveActionSheet(
                                  context: context,
                                  actions: [
                                    BottomSheetAction(
                                        title: const Text('logout'),
                                        onPressed: () {
                                          Navigator.of(context).popUntil(
                                            (route) => route.isFirst,
                                          );

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        }),
                                  ]);
                            },
                            child: Text(
                              "$username's account",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          OutlinedButton(
                            // style: ButtonStyle(),
                            onPressed: () {
                              bloc.add(StartedEvent());
                            },
                            child: Text(
                              "Reload",
                              style: TextStyle(color: Colors.black45),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPage(
                                      transactionType: "Income",
                                      transactions: state.transactions
                                          .where((element) =>
                                              element.type == "Income")
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                              child: _totalIncome(state.totalIncome)),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPage(
                                      transactionType: "Expense",
                                      transactions: state.transactions
                                          .where((element) =>
                                              element.type == "Expense")
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                              child: _totalExpense(state.totalExpense)),
                          _summary(state.summary),
                        ],
                      ),
                    ],
                  ),
                ),
                //
                SizedBox(height: 16),
                //
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black38,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Transactions",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _transactionList(state.transactions),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalIncome(num totalIncome) {
    return _numberBox(
      value: totalIncome,
      label: "Income",
      color: Colors.lightGreen,
    );
  }

  Widget _totalExpense(num totalExpense) {
    return _numberBox(
      value: totalExpense,
      label: "Expense",
      color: Colors.red,
    );
  }

  Widget _summary(num summary) {
    return _numberBox(
      value: summary,
      label: "Summary",
      color: (summary < 0) ? Colors.red : Colors.lightGreen,
    );
  }

  Widget _numberBox({
    required num value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(80),
            border: Border.all(width: 4, color: color),
          ),
          child: Text(
            value.toStringAsFixed(1),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _transactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text("No Transaction"),
      );
    }

    transactions.sort((a, b) => (a.at.compareTo(b.at)));

    return Column(
        children: transactions.reversed.map(
      (e) {
        final atDate = e.at.toDate();
        final atString =
            "${atDate.day}/${atDate.month}/${atDate.year} ${atDate.hour}:${atDate.minute}";

        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
              color: Colors.black26,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  (e.type == "Income") ? Icon(Icons.add) : Icon(Icons.remove),
                  Text(
                    e.product,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(atString),
                ],
              ),
              Text("${e.amount}")
            ],
          ),
        );
      },
    ).toList());
  }

  Widget _loadFailureContent(BuildContext context, LoadFailureState state) {
    return Column(
      children: [Text(state.error)],
    );
  }
}
