// signIn.dart
import "../../imports.dart";
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  // loginBloc aus registrierung.dart
  final LoginBloc loginBloc;
  SignIn({this.loginBloc});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with Validators {
  // key für das Form Widget
  final _formKey = GlobalKey<FormState>();

  LoginBloc _loginBloc;
  GamesBloc _gameBloc;
  FriendsBloc _friendsBloc;

  // authenticationService to sign in the user
  AuthenticationService authenticationService = AuthenticationService();
  // controller for both TextFormFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  // fields for the password TextFormField
  bool _passwortIstVerdeckt = true;
  Icon _passwortIcon = Icon(Icons.visibility);

  @override
  void initState() {
    super.initState();
    this._loginBloc = LoginBloc(
      authenticationService: AuthenticationService(),
      cloudFirestoreDatabase: CloudFirestoreDatabase(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GamesBlocProvider.of(context).gamesBloc;
    this._friendsBloc = FriendsBlocProvider.of(context).friendsBloc;
  }

  // gets called when the user wants to reset his password
  void resetPassword(BuildContext currentContext) async {
    await showDialog(
        context: currentContext,
        builder: (BuildContext context) {
          DialogTheme dialogTheme = Theme.of(context).dialogTheme;
          TextEditingController _emailControllerInFunction =
              TextEditingController();
          _emailControllerInFunction.text = "";
          return Dialog(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Passwort zurücksetzen",
                      style: dialogTheme.titleTextStyle,
                    ),
                    Text(
                      "Bitte gib die Email Adresse deines JustChess Kontos an",
                      style: dialogTheme.contentTextStyle,
                    ),
                    TextField(
                      controller: _emailControllerInFunction,
                      style: dialogTheme.contentTextStyle,
                      decoration: InputDecoration(
                        labelText: "Email Adresse",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          child: Text(
                            "Bestätigen",
                            style: dialogTheme.contentTextStyle,
                          ),
                          onPressed: () async {
                            try {
                              await authenticationService
                                  .sendResetPasswortEmail(
                                      email: _emailControllerInFunction.text ??
                                          "");
                              Navigator.pop(context);
                              Scaffold.of(currentContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Passwort zurücksetzen Email versendet"),
                                ),
                              );
                            } on PlatformException catch (platformException) {
                              Navigator.pop(context);
                              // shows a SnackBar with the given error
                              SnackbarMessage(
                                context: currentContext,
                                message: platformException.message ?? "",
                              ).showSnackBar();
                            } catch (error) {
                              Navigator.pop(context);
                              SnackbarMessage(
                                context: currentContext,
                                message: error.toString(),
                              ).showSnackBar();
                              print(error.toString());
                            }
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Abbrechen",
                            style: dialogTheme.contentTextStyle,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Anmeldung"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // TODO: create better validators
                TextFormField(
                  decoration: InputDecoration(labelText: "E-Mail Adresse"),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  autocorrect: false,
                  validator: (String email) => checkEmail(email: email),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Passwort",
                    suffix: IconButton(
                      icon: _passwortIcon,
                      onPressed: () {
                        if (this._passwortIstVerdeckt) {
                          setState(() {
                            _passwortIstVerdeckt = false;
                            _passwortIcon = Icon(Icons.visibility_off);
                          });
                        } else {
                          setState(() {
                            _passwortIstVerdeckt = true;
                            _passwortIcon = Icon(Icons.visibility);
                          });
                        }
                      },
                    ),
                  ),
                  controller: _passwortController,
                  obscureText: _passwortIstVerdeckt,
                  maxLines: 1,
                  autocorrect: false,
                  validator: (String password) =>
                      checkSignInPassword(password: password),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (BuildContext currentContext) => FlatButton(
                      child: Text(
                        "Passwort zurücksetzen",
                      ),
                      onPressed: () => resetPassword(currentContext),
                    ),
                  ),
                ),
                // TODO: dem User eine Benachrichtigung / ein Feedback anzeigen, z.B. "Passwort ist falsch"
                Builder(
                  builder: (BuildContext currentContext) => RaisedButton(
                    child: Text("Anmelden"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          await _loginBloc.signIn(
                              email: _emailController.text,
                              password: _passwortController.text);
                          // refreshes the list of games (otherwise snapshot wouldn't connect)
                          _gameBloc.refreshAllAfterSigningIn();
                          _friendsBloc.refresh();
                          Navigator.pop(context);
                        } on PlatformException catch (platformException) {
                          SnackbarMessage(
                            context: currentContext,
                            message: platformException.message,
                          );
                        } catch (error) {
                          print(error.toString());
                          SnackbarMessage(
                            context: currentContext,
                            message: error.toString(),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
