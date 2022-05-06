import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:income_expense_tracker/src/app/cubits/authentication_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/dialog_cubit.dart';
import 'package:income_expense_tracker/src/app/cubits/router_cubit.dart';
import 'package:income_expense_tracker/src/common/widgets/app_dialog.dart';
import 'package:income_expense_tracker/src/pages/login_page/login_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (_) => AuthenticationCubit(),
        ),
        BlocProvider<DialogCubit>(
          create: (_) => DialogCubit(),
        ),
        BlocProvider<RouterCubit>(
          create: (_) => RouterCubit(),
        ),
      ],
      child: _app(
        title: "Income Outcome Tracker",
        theme: _theme(),
        home: MultiBlocListener(
          listeners: [
            BlocListener<DialogCubit, DialogData?>(
              listener: (context, dialogData) {
                if (dialogData == null) return;

                showDialog(
                  context: context,
                  builder: (context) {
                    return AppDialog(
                      title: dialogData.title,
                      content: dialogData.content,
                      proceedButtonLabel: dialogData.proceedButtonLabel,
                      proceedHandler: dialogData.proceedHandler,
                    );
                  },
                );
              },
            ),
            BlocListener<RouterCubit, RouterCubitState?>(
              listener: (context, state) {
                switch (state.runtimeType) {
                  case PushState:
                    {
                      final pushState = state as PushState;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pushState.page,
                        ),
                      );

                      pushState.onNavigated();

                      break;
                    }
                  case PushReplacementState:
                    {
                      final pushReplacementState =
                          state as PushReplacementState;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pushReplacementState.page,
                        ),
                      );

                      pushReplacementState.onNavigated();

                      break;
                    }
                  case PopState:
                    {
                      final popState = state as PopState;

                      Navigator.pop(context);

                      popState.onNavigated();

                      break;
                    }
                  default:
                    return;
                }
              },
            )
          ],
          child: LoginPage(),
        ),
      ),
    );
  }

  Widget _app({
    required String title,
    required Widget home,
    ThemeData? theme,
  }) {
    return MaterialApp(
      title: title,
      theme: theme,
      home: home,
    );
  }

  ThemeData _theme() {
    return ThemeData(
      primaryColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
