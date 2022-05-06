import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:income_expense_tracker/src/common/widgets/app_page.dart';
import 'package:income_expense_tracker/src/pages/add_transaction_page/add_transaction_page.dart';

import '../../models/Transaction.dart';
import 'bloc/transaction_page_bloc.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({
    required this.transactionType,
    required this.transactions,
  }) : super();

  final String transactionType;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: _title(context),
      content: _content(context),
    );
  }

  String _title(BuildContext context) {
    return transactionType;
  }

  Widget _content(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionPageBloc(transactions: transactions),
      child: BlocBuilder<TransactionPageBloc, TransactionPageState>(
        builder: (context, state) {
          return _mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget _mapStateToContent(
    BuildContext context,
    TransactionPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return _initialContent(context, state as InitialState);
      case LoadSuccessState:
        return _loadSuccessContent(context, state as LoadSuccessState);
      default:
        throw new Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget _initialContent(
    BuildContext context,
    TransactionPageState state,
  ) {
    context.read<TransactionPageBloc>().add(StartedEvent());

    return Container();
  }

  Widget _loadSuccessContent(
    BuildContext context,
    LoadSuccessState state,
  ) {
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
}
