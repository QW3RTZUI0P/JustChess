// signUp.dart
import "../imports.dart";
import 'package:JustChess/services/cloudFirestoreDatabase.dart';
import 'package:flutter/services.dart';
import "package:flutter/gestures.dart";

// TODO: make this english
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with Validators {
  // key für das Form Widget
  final _formKey = GlobalKey<FormState>();
  // loginBloc für die gesamte Registrierungslogik
  LoginBloc _loginBloc;
  GamesBloc _gamesBloc;
  // TextEditingController für die Textfelder
  final TextEditingController _benutzernameController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  // value for the Terms of conditions and the Privacy policy
  bool _checkboxValue = false;
  Color _checkboxColor = Colors.grey.shade50;
  // fields die speichern, ob der Text in den Passwörter Textfeldern angezeigt werden soll
  bool _passwortIstVerdeckt = true;
  // fields die die angezeigten icons in den Passwört Textfeldern speichern
  Icon _passwortIcon = Icon(Icons.visibility);

  // gesture recognizer for the hyperlinks to TermsOfUse and PrivacyPolicy
  TapGestureRecognizer _termsOfUseTapRecognizer;
  TapGestureRecognizer _privacyPolicyTapRecognizer;

  @override
  void initState() {
    super.initState();
    this._loginBloc = LoginBloc(
      authenticationService: AuthenticationService(),
      cloudFirestoreDatabase: CloudFirestoreDatabase(),
    );
    _termsOfUseTapRecognizer = TapGestureRecognizer()
      ..onTap = _launchTermsOfUse;
    _privacyPolicyTapRecognizer = TapGestureRecognizer()
      ..onTap = _launchPrivacyPolicy;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  @override
  void dispose() {
    _termsOfUseTapRecognizer.dispose();
    _privacyPolicyTapRecognizer.dispose();
    super.dispose();
  }

  void _launchTermsOfUse() async {
    const url = "https://justchess.github.io/termsOfUse.md";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  void _launchPrivacyPolicy() async {
    const url = "https://justchess.github.io/privacyPolicy.md";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle checkboxTextStyle = theme.textTheme.bodyText1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrierung"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            8,
            0,
            8,
            0,
          ),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Textfeld für den Benutzernamen
                TextFormField(
                  decoration: InputDecoration(labelText: "Benutzername"),
                  controller: _benutzernameController,
                  maxLines: 1,
                  maxLength: 40,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onFieldSubmitted: (_) {
                    _formKey.currentState.validate();
                  },
                  validator: (benutzername) {
                    return checkUsername(benutzername: benutzername);
                  },
                ),
                // textfield for the password
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Passwort",
                    suffix: IconButton(
                      icon: _passwortIcon,
                      onPressed: () {
                        setState(() {
                          if (this._passwortIstVerdeckt) {
                            _passwortIstVerdeckt = false;
                            _passwortIcon = Icon(Icons.visibility_off);
                          } else {
                            _passwortIstVerdeckt = true;
                            _passwortIcon = Icon(Icons.visibility);
                          }
                        });
                      },
                    ),
                  ),
                  controller: _passwortController,
                  maxLines: 1,
                  obscureText: _passwortIstVerdeckt,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onFieldSubmitted: (_) {
                    _formKey.currentState.validate();
                  },
                  validator: (passwort) {
                    return checkPassword(password: passwort);
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          style: BorderStyle.solid,
                          color: _checkboxColor,
                        ),
                      ),
                      child: Checkbox(
                          value: _checkboxValue,
                          onChanged: (bool newValue) {
                            setState(() {
                              _checkboxValue = newValue;
                              if (newValue) {
                                _checkboxColor = Colors.grey.shade50;
                              }
                            });
                          }),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RichText(
                        maxLines: 10,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: "Indem Sie fortfahren stimmen Sie unseren ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "Nutzungsbedingungen ",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: _termsOfUseTapRecognizer,
                              ),
                              TextSpan(text: "und unseren "),
                              TextSpan(
                                text: "Datenschutzbestimmungen ",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: _privacyPolicyTapRecognizer,
                              ),
                              TextSpan(text: "zu.")
                            ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),

                Builder(
                  builder: (BuildContext currentContext) => RaisedButton(
                    child: Text("Account erstellen"),
                    onPressed: () async {
                      // TODO: make username control prettier
                      if (_formKey.currentState.validate() && _checkboxValue) {
                        if (await _loginBloc.isUsernameAvailable(
                            username: _benutzernameController.text)) {
                          try {
                            print("trying create account");
                            await _loginBloc.createAccount(
                              password: _passwortController.text,
                              username: _benutzernameController.text,
                            );

                            // refreshes the list of games (otherwise snapshot wouldn't connect)
                            _gamesBloc.refreshAllAfterSigningIn();
                          } on PlatformException catch (platformException) {
                            print(platformException.toString());
                            SnackbarMessage(
                              context: currentContext,
                              message: platformException.message,
                            );
                          } catch (error) {
                            print(error.toString());
                            SnackbarMessage(
                                context: currentContext,
                                message: error.toString());
                          }
                        } else {
                          SnackbarMessage(
                              context: currentContext,
                              message:
                                  "Dieser Benutzername ist schon vergeben");
                        }
                      } else {
                        if (_checkboxValue == false) {
                          // TODO: make the checkbox validation
                          setState(() {
                            _checkboxColor = Colors.red;
                          });
                        }
                      }
                    },
                  ),
                ),
                FlatButton(
                  child: Text("Stattdessen anmelden"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return SignIn();
                          }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
