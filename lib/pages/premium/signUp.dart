// signUp.dart
import "../../imports.dart";
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

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

  @override
  Widget build(BuildContext context) {
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
                    return checkPassword(passwort: passwort);
                  },
                ),

                // TODO: implement Sign In With Apple
                RaisedButton(
                  child: Text("Registrieren"),
                  onPressed: () async {
                    // TODO: implementieren, was passiert wenn der Account schon benutzt wird
                    // TODO: make username control prettier
                    // TODO: implement email is in use control
                    if (_formKey.currentState.validate()) {
                      if (await _loginBloc.isUsernameAvailable(
                          username: _benutzernameController.text)) {
                        _loginBloc
                            .createAccount(
                              email: _emailController.text,
                              password: _passwortController.text,
                              username: _benutzernameController.text,
                            )
                            // refreshes the list of games (otherwise snapshot wouldn't connect)
                            .then((value) => _gamesBloc.refresh());
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text("Der Benutzername ist schon vergeben"),
                                content: Text(
                                    "Wähle bitte einen anderen Benutzernamen"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            });
                      }
                    }
                  },
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
