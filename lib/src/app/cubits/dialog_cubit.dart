import 'package:flutter_bloc/flutter_bloc.dart';

part 'dialog_data.dart';

class DialogCubit extends Cubit<DialogData?> {
  DialogCubit() : super(null);

  void show({
    required String title,
    required String content,
    String? proceedButtonLabel,
    Function? proceedHandler,
    String? dismissButtonLabel,
    Function? dismissHandler,
  }) {
    emit(DialogData(
      title: title,
      content: content,
      proceedButtonLabel: proceedButtonLabel,
      proceedHandler: proceedHandler,
      dismissButtonLabel: dismissButtonLabel,
      dismissHandler: () {
        if (dismissHandler != null) {
          dismissHandler();
        }

        dismiss();
      },
    ));
  }

  void dismiss() {
    emit(null);
  }
}
