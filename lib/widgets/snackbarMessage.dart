// snackbarMessage.dart
import "../imports.dart";

// shows a SnackBar with an error message whenever an error is thrown
class SnackbarMessage {
  final String message;
  final BuildContext context;
  ThemeData theme;

  SnackbarMessage({this.message = "", this.context}) : assert(context != null) {
    this.theme = Theme.of(context);
    showSnackBar();
  }

  void showSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? "",
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: theme.snackBarTheme.contentTextStyle,
        ),
      ),
    );
  }
}
