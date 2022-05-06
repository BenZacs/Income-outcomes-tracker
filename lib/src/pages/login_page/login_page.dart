import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';
import 'package:intersperse/intersperse.dart';

import 'package:income_expense_tracker/src/common/widgets/app_page.dart';
import 'package:income_expense_tracker/src/common/widgets/loading_indicator.dart';

import 'bloc/login_page_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _showValidationError = false;
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: _title(context),
      content: _content(context),
    );
  }

  String _title(BuildContext context) {
    return "Income & Expense Tracker";
  }

  Widget _content(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginPageBloc(
          dialogCubit: context.read<DialogCubit>(),
          routerCubit: context.read<RouterCubit>()),
      child: BlocBuilder<LoginPageBloc, LoginPageState>(
        builder: (context, state) {
          return _mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget _mapStateToContent(
    BuildContext context,
    LoginPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return _initialContent(context, state as InitialState);
      case LoadSuccessState:
        return _loadSuccessContent(context, state as LoadSuccessState);
      case LoginRequestingState:
        return _loginRequestingContent(context, state as LoginRequestingState);
      default:
        throw new Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget _initialContent(
    BuildContext context,
    LoginPageState state,
  ) {
    context.read<LoginPageBloc>().add(StartedEvent());

    return Container();
  }

  Widget _loadSuccessContent(
    BuildContext context,
    LoadSuccessState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _appLogo(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              _usernameField(),
              //
              const SizedBox(height: 16),
              //
              _passwordField(),
              //
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'don\'t have an account? ',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    //
                    _registerButton(context),
                  ].intersperse(const SizedBox(width: 8)).toList()),
              //
              const SizedBox(height: 8),
              //
              _loginButton(context)
            ]),
          )
        ],
      ),
    );
  }

  Widget _appLogo() {
    return Image(
      image: AssetImage('images/login-image.jpeg'),
      fit: BoxFit.fill,
    );
  }

  Widget _usernameField() {
    return TextField(
      controller: _usernameFieldController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Username',
        errorText: _showValidationError
            ? _fieldErrorText(_usernameFieldController)
            : null,
      ),
      onChanged: (text) {
        setState(() {
          _username = text;
        });
      },
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          errorText: _showValidationError
              ? _fieldErrorText(_passwordFieldController)
              : null),
      onChanged: (text) {
        setState(() {
          _password = text;
        });
      },
    );
  }

  String? _fieldErrorText(TextEditingController controller) {
    final text = controller.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  Widget _loginButton(BuildContext context) {
    final bloc = context.read<LoginPageBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.lightGreen,
          padding: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      onPressed: () {
        final isLoginFormValid = _username.isNotEmpty && _password.isNotEmpty;

        if (isLoginFormValid) {
          bloc.add(LoginRequestedEvent(_username, _password));
        } else {
          setState(() {
            _showValidationError = true;
          });
        }
      },
      child: Text(
        'Login',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    final bloc = context.read<LoginPageBloc>();

    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      onPressed: () {
        bloc.add(RegisterRequestedEvent());
      },
      child: Text(
        'Register',
        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
      ),
    );
  }

  Widget _loginRequestingContent(
    BuildContext context,
    LoginRequestingState state,
  ) {
    return LoadingIndicator();
  }
}
