import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';

import 'package:income_expense_tracker/src/common/widgets/app_page.dart';
import 'package:income_expense_tracker/src/common/widgets/loading_indicator.dart';

import 'bloc/register_page_bloc.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage() : super();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _confirmPasswordFieldController = TextEditingController();
  bool _showValidationError = false;
  String _username = "";
  String _password = "";
  String _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: _title(context),
      content: _content(context),
    );
  }

  String _title(BuildContext context) {
    return "Account Registration";
  }

  Widget _content(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterPageBloc(
        dialogCubit: context.read<DialogCubit>(),
        routerCubit: context.read<RouterCubit>(),
      ),
      child: BlocBuilder<RegisterPageBloc, RegisterPageState>(
        builder: (context, state) {
          return _mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget _mapStateToContent(
    BuildContext context,
    RegisterPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return _initialContent(context, state as InitialState);
      case LoadSuccessState:
        return _loadSuccessContent(context, state as LoadSuccessState);
      case RegisterRequestingState:
        return _registerRequestingContent(
            context, state as RegisterRequestingState);
      default:
        throw new Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget _initialContent(
    BuildContext context,
    RegisterPageState state,
  ) {
    context.read<RegisterPageBloc>().add(StartedEvent());

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
              const SizedBox(height: 16),
              //
              _confirmPasswordField(),
              //
              const SizedBox(height: 32),
              //
              _registerButton(context)
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
        errorText: _showValidationError ? _usernameFieldErrorText() : null,
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
          errorText: _showValidationError ? _passwordFieldErrorText() : null),
      onChanged: (text) {
        setState(() {
          _password = text;
        });
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextField(
      controller: _confirmPasswordFieldController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Confirm Password',
          errorText:
              _showValidationError ? _confirmPasswordFieldErrorText() : null),
      onChanged: (text) {
        setState(() {
          _confirmPassword = text;
        });
      },
    );
  }

  String? _usernameFieldErrorText() {
    final text = _usernameFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  String? _passwordFieldErrorText() {
    final passwordText = _usernameFieldController.value.text;
    final confirmPasswordText = _usernameFieldController.value.text;

    if (passwordText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (passwordText != confirmPasswordText) {
      return 'Passwords are not matching';
    }

    return null;
  }

  String? _confirmPasswordFieldErrorText() {
    final passwordText = _usernameFieldController.value.text;
    final confirmPasswordText = _usernameFieldController.value.text;

    if (confirmPasswordText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (passwordText != confirmPasswordText) {
      return 'Passwords are not matching';
    }

    return null;
  }

  Widget _registerButton(BuildContext context) {
    final bloc = context.read<RegisterPageBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.lightGreen,
          padding: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      onPressed: () {
        final isPasswordAndConfirmPasswordMatched =
            _password == _confirmPassword;
        final isFieldNotEmpty = _username.isNotEmpty &&
            _password.isNotEmpty &&
            _confirmPassword.isNotEmpty;
        final isRegisterFormValid =
            isFieldNotEmpty && isPasswordAndConfirmPasswordMatched;

        if (isRegisterFormValid) {
          bloc.add(RegisterRequestedEvent(_username, _password));
        } else {
          setState(() {
            _showValidationError = true;
          });
        }
      },
      child: Text(
        'Register',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _registerRequestingContent(
    BuildContext context,
    RegisterRequestingState state,
  ) {
    return LoadingIndicator();
  }
}
