// registrierung.dart
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

import "../imports.dart";

class Registrierung extends StatefulWidget {
  @override
  _RegistrierungState createState() => _RegistrierungState();
}

class _RegistrierungState extends State<Registrierung> with Validatoren {
  // key für das Form Widget
  final _formKey = GlobalKey<FormState>();
  // loginBloc für die gesamte Registrierungslogik
  LoginBloc _loginBloc;
  // TextEditingController für die Textfelder
  final TextEditingController _benutzernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  final TextEditingController _passwortWiederholungController =
      TextEditingController();

  // fields die speichern, ob der Text in den Passwörter Textfeldern angezeigt werden soll
  bool _passwortIstVerdeckt = true;
  bool _passwortWiederholungIstVerdeckt = true;
  // fields die die angezeigten icons in den Passwört Textfeldern speichern
  Icon _passwortIcon = Icon(Icons.visibility);
  Icon _passwortWiederholungIcon = Icon(Icons.visibility);

  @override
  void initState() {
    super.initState();
    this._loginBloc = LoginBloc(
      authenticationService: AuthenticationService(),
      cloudFirestoreDatabase: CloudFirestoreDatabase(),
    );
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
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onFieldSubmitted: (_) {
                    _formKey.currentState.validate();
                  },
                  validator: (benutzername) {
                    return checkeBenutzername(benutzername: benutzername);
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
                    return checkeEmailAdresse(email: email);
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
                    return checkePasswort(passwort: passwort);
                  },
                ),
                // Textfeld für die Wiederholung des Passwortes
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Passwort wiederholen",
                    suffix: IconButton(
                      icon: _passwortWiederholungIcon,
                      onPressed: () {
                        setState(() {
                          if (this._passwortWiederholungIstVerdeckt) {
                            _passwortWiederholungIstVerdeckt = false;
                            _passwortWiederholungIcon =
                                Icon(Icons.visibility_off);
                          } else {
                            _passwortWiederholungIstVerdeckt = true;
                            _passwortWiederholungIcon = Icon(Icons.visibility);
                          }
                        });
                      },
                    ),
                  ),
                  controller: _passwortWiederholungController,
                  maxLines: 1,
                  obscureText: _passwortWiederholungIstVerdeckt,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onFieldSubmitted: (_) {
                    _formKey.currentState.validate();
                  },
                  validator: (passwortWiederholung) {
                    return checkePasswortWiederholung(
                        passwort: _passwortController.text,
                        passwortWiederholung: passwortWiederholung);
                  },
                ),
                // TODO: implement Sign In With Apple
                RaisedButton(
                  child: Text("Registrieren"),
                  onPressed: () {
                    // TODO: implementieren, was passiert wenn der Account schon benutzt wird
                    if (_formKey.currentState.validate()) {
                      _loginBloc.createAccount(
                          email: _emailController.text,
                          password: _passwortController.text,
                          username: _benutzernameController.text,
                          );
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
                            return Anmeldung();
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
