// authenticationBloc.dart
import "../imports.dart";

// TODO: fix bug when changing the isUserPremium Status to often

// class that handles authentication and checks whether the user is premium or not
class AuthenticationBloc {
  final AuthenticationApi authenticationService;

  // will be replaced with AppStore Subscription value
  // StreamController that tracks whether the user is a premium user
  StreamController<bool> _isUserPremiumController = StreamController<bool>();
  Sink<bool> get isUserPremiumSink => _isUserPremiumController.sink;
  Stream<bool> get isUserPremiumStream => _isUserPremiumController.stream;

  // Stream, der den Status der Authentisierung überwacht
  StreamController<String> _authenticationController =
      StreamController<String>();
  // wenn sich der Status ändert, wird diesem Sink etwas hinzugefügt
  Sink<String> get addUser => _authenticationController.sink;
  // wenn dem Sink addUser etwas hinzugefügt wird, wird dieser Stream benachrichtigt
  Stream<String> get user => _authenticationController.stream;
  // checks whether the user has logged out
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc({this.authenticationService}) {
    startListeners();
    getUserStatus();
  }

  void getUserStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isUserPremium = sharedPreferences.getBool("isUserPremium") ?? false;
    isUserPremiumSink.add(isUserPremium);
  }

  // überwacht die ganze Zeit, ob der User ein- oder ausgeloggt ist
  void startListeners() async {
    await authenticationService.getFirebaseAuth();
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

  // closes the three StreamControllers
  void dispose() {
    _isUserPremiumController.close();
    _authenticationController.close();
    _logoutController.close();
  }
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
