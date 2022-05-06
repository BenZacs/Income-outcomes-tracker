part of 'dialog_cubit.dart';

class DialogData {
  DialogData({
    required this.title,
    required this.content,
    required this.proceedButtonLabel,
    required this.proceedHandler,
    required this.dismissButtonLabel,
    required this.dismissHandler,
  });

  final String title;
  final String content;
  final String? proceedButtonLabel;
  final Function? proceedHandler;
  final String? dismissButtonLabel;
  final Function? dismissHandler;
}
