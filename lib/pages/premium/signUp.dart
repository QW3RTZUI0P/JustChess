// signUp.dart
import "../../imports.dart";
import 'package:JustChess/services/cloudFirestoreDatabase.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  // value for the Terms of conditions and the Privacy policy
  bool checkboxValue = false;
  Color checkboxColor = Colors.black;
  // fields die speichern, ob der Text in den Passwörter Textfeldern angezeigt werden soll
  bool _passwortIstVerdeckt = true;
  // fields die die angezeigten icons in den Passwört Textfeldern speichern
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
    this._gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  void _launchPrivacyPolicy() async {
    const url = "https://jumelon.github.io/privacy.md";
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
            autovalidate: false,
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
                // Textfled für die Email Addresse
                TextFormField(
                  decoration: InputDecoration(labelText: "E-Mail Adresse"),
                  controller: _emailController,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onFieldSubmitted: (_) {
                    _formKey.currentState.validate();
                  },
                  validator: (email) {
                    return checkEmail(email: email);
                  },
                ),
                // Textfeld für das Passwort
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
                RichText(
                  maxLines: 10,
                  text: TextSpan(
                      text: "Indem Sie fortfahren stimmen Sie unseren ",
                      children: [
                        TextSpan(text: "Nutzungsbedingungen "),
                        TextSpan(text: "und unseren "),
                        TextSpan(text: "Datenschutzbestimmungen "),
                        TextSpan(text: "zu.")
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Indem Sie fortfahren stimmen sie unseren ",
                      style: theme.textTheme.bodyText1,
                    ),
                    // TODO: implement Theme here for dark mode
                    FlatButton(
                      child: Text(
                        "Datenschutzbestimmungen",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => _launchPrivacyPolicy(),
                    ),
                    Text(" zu!", style: theme.textTheme.bodyText1)
                  ],
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Checkbox(
                //       value: checkboxValue,
                //       onChanged: (bool newValue) {
                //         setState(() {
                //           checkboxValue = newValue;
                //         });
                //       },
                //     ),
                //     Expanded(
                //       child: Text(
                //         "Ich stimme den Nutzungsbedingungen und den Datenschutzbestimmungen zu.",
                //         // TODO: make this compatible with the theme
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 10,
                //       ),
                //     ),
                //   ],
                // ),

                // TODO: implement Sign In With Apple
                Builder(
                  builder: (BuildContext currentContext) => RaisedButton(
                    child: Text("Account erstellen"),
                    onPressed: () async {
                      // TODO: make username control prettier
                      if (_formKey.currentState.validate() && checkboxValue) {
                        if (await _loginBloc.isUsernameAvailable(
                            username: _benutzernameController.text)) {
                          try {
                            await _loginBloc.createAccount(
                              email: _emailController.text,
                              password: _passwortController.text,
                              username: _benutzernameController.text,
                            );

                            // refreshes the list of games (otherwise snapshot wouldn't connect)
                            _gamesBloc.refreshAllAfterSigningIn();
                          } on PlatformException catch (platformException) {
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
                        if (checkboxValue == false) {
                          // TODO: make the checkbox validation

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
