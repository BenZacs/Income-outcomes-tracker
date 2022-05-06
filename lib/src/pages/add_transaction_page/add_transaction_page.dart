import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';

import 'package:income_expense_tracker/src/common/widgets/app_page.dart';
import 'package:income_expense_tracker/src/common/widgets/loading_indicator.dart';
import 'package:income_expense_tracker/src/models/Transaction.dart';

import 'bloc/add_transaction_page_bloc.dart';

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage() : super();

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _productNameFieldController = TextEditingController();
  final _amountFieldController = TextEditingController();
  bool _showValidationError = false;
  String _productName = "";
  double _amount = 0;
  String _transactionType = "Income";

  CollectionReference transactionsCollection = FirebaseFirestore.instance
      .collection('transactions')
      .withConverter<Transaction>(
        fromFirestore: (snapshot, _) => Transaction.fromJson(snapshot.data()!),
        toFirestore: (transaction, _) => transaction.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: _title(context),
      content: _content(context),
    );
  }

  String _title(BuildContext context) {
    return "Add Transaction";
  }

  Widget _content(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionPageBloc(
        dialogCubit: context.read<DialogCubit>(),
        routerCubit: context.read<RouterCubit>(),
        transactionsCollection: transactionsCollection,
      ),
      child: BlocBuilder<AddTransactionPageBloc, AddTransactionPageState>(
        builder: (context, state) {
          return _mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget _mapStateToContent(
    BuildContext context,
    AddTransactionPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return _initialContent(context, state as InitialState);
      case LoadSuccessState:
        return _loadSuccessContent(context, state as LoadSuccessState);
      case AddTransactionRequestingState:
        return _addTransactionRequestingContent(
            context, state as AddTransactionRequestingState);
      default:
        throw new Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget _initialContent(
    BuildContext context,
    AddTransactionPageState state,
  ) {
    context.read<AddTransactionPageBloc>().add(StartedEvent());

    return Container();
  }

  Widget _loadSuccessContent(
    BuildContext context,
    LoadSuccessState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _transactionTypePicture(),
          //
          const SizedBox(height: 32),
          //
          _transactionTypeField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              children: [
                _productNameField(),
                //
                const SizedBox(height: 16),
                //
                _amountField(),
                //
                const SizedBox(height: 32),
                //
                _addTransactionButton(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _transactionTypePicture() {
    return Image(
      image: (_transactionType == "Income")
          ? AssetImage('images/income.jpeg')
          : AssetImage('images/expense.jpeg'),
      fit: BoxFit.fill,
    );
  }

  Widget _transactionTypeField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Transaction Type",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          DropdownButton<String>(
            value: _transactionType,
            icon: (_transactionType == "Income")
                ? const Icon(Icons.add)
                : const Icon(Icons.remove),
            elevation: 16,
            style: TextStyle(color: Colors.black54, fontSize: 16),
            underline: Container(
              height: 2,
              color: (_transactionType == "Income") ? Colors.green : Colors.red,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _transactionType = newValue!;
              });
            },
            items: <String>['Income', 'Expense']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _productNameField() {
    return TextField(
      controller: _productNameFieldController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'From What',
        errorText: _showValidationError ? _productNameFieldErrorText() : null,
      ),
      onChanged: (text) {
        setState(() {
          _productName = text;
        });
      },
    );
  }

  String? _productNameFieldErrorText() {
    final text = _productNameFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  Widget _amountField() {
    return TextField(
      controller: _amountFieldController,
      decoration: new InputDecoration(
        labelText: "Amount",
        border: OutlineInputBorder(),
        errorText: _showValidationError ? _amountFieldErrorText() : null,
      ),
      keyboardType: TextInputType.number,
      onChanged: (amount) {
        setState(() {
          _amount = double.parse(amount);
        });
      },
    );
  }

  String? _amountFieldErrorText() {
    final text = _amountFieldController.value.text;

    try {
      final amount = double.parse(text);

      if (amount <= 0) {
        return 'Must be greater than 0';
      }
    } catch (error) {
      return 'Must be a number';
    }

    return null;
  }

  Widget _addTransactionButton(BuildContext context) {
    final bloc = context.read<AddTransactionPageBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary:
              (_transactionType == "Income") ? Colors.lightGreen : Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      onPressed: () {
        final isAddTransactionFormValid =
            _productName.isNotEmpty && _amount > 0 && _transactionType != "";

        if (isAddTransactionFormValid) {
          switch (_transactionType) {
            case 'Income':
              {
                bloc.add(
                  AddTransactionRequestedEvent(
                    transaction: Transaction(
                      type: "Income",
                      product: _productName,
                      amount: _amount,
                      at: Timestamp.now(),
                    ),
                  ),
                );

                break;
              }
            case 'Expense':
              {
                bloc.add(
                  AddTransactionRequestedEvent(
                    transaction: Transaction(
                      type: "Expense",
                      product: _productName,
                      amount: _amount,
                      at: Timestamp.now(),
                    ),
                  ),
                );

                break;
              }
            default:
              throw Exception("Invalid Transaction Type: $_transactionType");
          }
        } else {
          setState(() {
            _showValidationError = true;
          });
        }
      },
      child: Text(
        'add',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _addTransactionRequestingContent(
    BuildContext context,
    AddTransactionRequestingState state,
  ) {
    return LoadingIndicator();
  }
}
