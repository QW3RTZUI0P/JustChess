// anmeldung.dart
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

import "../imports.dart";

class Anmeldung extends StatefulWidget {
  // loginBloc aus registrierung.dart
  final LoginBloc loginBloc;
  Anmeldung({this.loginBloc});
  @override
  _AnmeldungState createState() => _AnmeldungState();
}

class _AnmeldungState extends State<Anmeldung> with Validatoren {
  // key für das Form Widget
  final _formKey = GlobalKey<FormState>();

  LoginBloc _loginBloc;

  // authenticationService, um den User anzumelden
  AuthenticationService authenticationService = AuthenticationService();
  // controller für die beiden TextFormFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  // fields für das Passwort TextFormField
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
  Widget build(BuildContext context) {
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
              children: <Widget>[
                // TODO: bessere validatoren einfügen
                TextFormField(
                  decoration: InputDecoration(labelText: "E-Mail Adresse"),
                  controller: _emailController,
                  maxLines: 1,
                  validator: (String email) {
                    return checkeEmailAdresse(email: email);
                  },
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
                  validator: (String passwort) {
                    return checkePasswort(passwort: passwort);
                  },
                ),
                // TODO: dem User eine Benachrichtigung / ein Feedback anzeigen, z.B. "Passwort ist falsch"
                RaisedButton(
                  child: Text("Anmelden"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _loginBloc.signIn(
                          email: _emailController.text,
                          password: _passwortController.text);
                      Navigator.pop(context);
                    }
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
