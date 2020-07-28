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

  // returns whether the user is premium or not
  void getUserStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // TODO: change this to false after debug phase is over
    bool isUserPremium = sharedPreferences.getBool("isUserPremium") ?? true;
    isUserPremiumSink.add(isUserPremium);
  }

  // checks all the time the user's authentication status
  void startListeners() async {
    await authenticationService.getFirebaseAuth();
    // is executed when the user logs in or logs out
    authenticationService.getFirebaseAuth().onAuthStateChanged.listen((user) {
      final String uid = user != null ? user.uid : null;
      addUser.add(uid);
    });
    // is executed when the user presses the logout button
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

// InheritedWidget that provides the authenticationBloc
class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;
  const AuthenticationBlocProvider(
      {Key key, Widget child, this.authenticationBloc})
      : super(key: key, child: child);
  static AuthenticationBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>();
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) {
    // returns true if the two InheritedWidgets differ from each other

    return authenticationBloc != oldWidget.authenticationBloc;
  }
}
