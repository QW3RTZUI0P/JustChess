// authenticationBloc.dart
import "../imports.dart";

// bloc Klasse, die sich um die Authentisierung kümmert
class AuthenticationBloc {
  final AuthenticationApi authenticationService;

  // Stream, der den Status der Authentisierung überwacht
  StreamController<String> _authenticationController =
      StreamController<String>();
  // wenn sich der Status ändert, wird diesem Sink etwas hinzugefügt
  Sink<String> get addUser => _authenticationController.sink;
  // wenn dem Sink addUser etwas hinzugefügt wird, wird dieser Stream benachrichtigt
  Stream<String> get user => _authenticationController.stream;
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;



  AuthenticationBloc({this.authenticationService}) {
    _startListeners();
  }

  // überwacht die ganze Zeit, ob der User ein- oder ausgeloggt ist
  void _startListeners() {
    // wenn der User sich einloggt/ausloggt wird das hier ausgeführt
    authenticationService.getFirebaseAuth().onAuthStateChanged.listen((user) {
      final String uid = user != null ? user.uid : null;
      addUser.add(uid);
    });
    // wenn der User auf den Ausloggen-Button drückt, wird dies hier ausgeführt
    _logoutController.stream.listen((logoutBool) {
      if (logoutBool == true) {
        authenticationService.signOut();
      }
    });
  }


  // schließt die beiden StreamController (aus Performance-Gründen)
  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }


  // ab hier Funktionen, die für die Registrierung und Anmeldung erforderlich sind

}

// InheritedWidget, das den AuthenticationBloc dem Widget Tree zur Verfügung stellt
class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;
  // key und child sind fields, die das InheritedWidget braucht
  const AuthenticationBlocProvider(
      {Key key, Widget child, this.authenticationBloc})
      : super(key: key, child: child);
  static AuthenticationBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>();
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) {
    // gibt nur true aus, wenn sich die beiden blocs unterscheiden

    return authenticationBloc != oldWidget.authenticationBloc;
  }
}
