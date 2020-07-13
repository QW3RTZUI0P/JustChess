// menu.dart
import "../../imports.dart";

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  AuthenticationBloc _authenticationBloc;
  GameBloc _gameBloc;

  String username;
  String emailAdress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
    getUserCredentials();
  }

  void getUserCredentials() async {
    Map<String, dynamic> credentials = await _authenticationBloc
        .authenticationService
        .currentUserCredentials();
    setState(() {
      this.username = credentials["username"];
      this.emailAdress = credentials["email"];
    });
  }

  void showUserOptionsDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Account Optionen"),
        content: Container(
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Text("Account löschen"),
                
                // onPressed: () {
                //   showDialog(
                //     context: context,
                //     child: AlertDialog(
                //       title: Text("Bestätigung"),
                //       content: Container(
                //         child: Row(
                //           children: <Widget>[
                //             FlatButton(
                //               child: Text("Abbrechen"),
                //               onPressed: () => Navigator.pop(context),
                //             ),
                //             FlatButton(
                //               child: Text("Ok"),
                //               onPressed: () async {
                //                 // deletes Account from FirebaseAuth
                //                 _authenticationBloc.authenticationService
                //                     .deleteAccount();
                //                 String usernameInFunction = await _gameBloc
                //                     .cloudFirestoreDatabase
                //                     .getUsernameForUserID(
                //                         userID: _gameBloc.currentUserID);
                //                 // deletes Account Info from CloudFirestore
                //                 _gameBloc.cloudFirestoreDatabase
                //                     .deleteUserFromFirestore(
                //                         userID: _gameBloc.currentUserID,
                //                         username: usernameInFunction);
                //                 Navigator.pop(context);
                //                 Navigator.pop(context);
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   );
                // },
              ),
              FlatButton(
                child: Text("Passwort zurücksetzen"),
                onPressed: () {
                  _authenticationBloc.authenticationService
                      .sendResetPasswortEmail();
                },
              ),
              FlatButton(
                child: Text("Datenschutzerklärung"),
                onPressed: () {},
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text("Abbrechen"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      child: CircleAvatar(),
                      onTap: () => showUserOptionsDialog(),
                    ),
                    Text("Benutzername: $username"),
                  ],
                ),
                Text("Email: $emailAdress"),
              ],
            ),
          ),
          ListTile(
            title: Text("Partien"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Freunde"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (BuildContext context) {
                      return Friends();
                    }),
              );
            },
          ),
          ListTile(
            title: Text("Über"),
          ),
          ListTile(
            title: Text("Ausloggen"),
            onTap: () async {
              _gameBloc.signOut();
              _authenticationBloc.authenticationService.signOut();
            },
          ),
        ],
      ),
    );
  }
}
