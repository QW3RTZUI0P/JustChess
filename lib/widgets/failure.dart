// failure.dart
import "../imports.dart";

// shows a SnackBar with an error message whenever an error is thrown
class Failure {
  final String errorMessage;
  final BuildContext context;

  Failure({this.errorMessage = "", this.context}) : assert (context != null);

  void showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }
}
