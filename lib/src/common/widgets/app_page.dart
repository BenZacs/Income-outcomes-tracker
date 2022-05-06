import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  const AppPage(
      {Key? key,
      this.floatingActionButton,
      this.appBarActions,
      required this.title,
      required this.content})
      : super(key: key);

  final String title;
  final Widget content;
  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;

  @override
  Widget build(BuildContext context) {
    return _page(
      tapHandler: _collapseKeyboard,
      appBar: _appBar(
        title: title,
        actions: appBarActions,
      ),
      content: content,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _page({
    required Function tapHandler,
    required AppBar appBar,
    required Widget content,
    required Widget? floatingActionButton,
  }) {
    return GestureDetector(
      onTap: () => tapHandler(),
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(child: content),
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  AppBar _appBar({
    required String title,
    List<Widget>? actions,
  }) {
    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  void _collapseKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
