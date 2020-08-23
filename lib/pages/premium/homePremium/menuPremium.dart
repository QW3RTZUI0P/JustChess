// menuPremium.dart
import "../../../imports.dart";

class MenuPremium extends StatefulWidget {
  @override
  _MenuPremiumState createState() => _MenuPremiumState();
}

class _MenuPremiumState extends State<MenuPremium> {
  AuthenticationBloc _authenticationBloc;
  GamesBloc _gameBloc;

  String username;
  String emailAdress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    this._gameBloc = GamesBlocProvider.of(context).gamesBloc;
    getUserCredentials();
  }

  void getUserCredentials() async {
    String emailAdress =
        await _authenticationBloc.authenticationService.currentUserEmail();
    String username = await CloudFirestoreDatabase()
        .getUsernameForUserID(userID: _gameBloc.currentUserID);
    setState(() {
      this.username = username;
      this.emailAdress = emailAdress;
    });
  }

  // we don't need this any more, this options are now in SettingsPremium
  // void showUserOptionsDialog() {
  //   showDialog(
  //     context: context,
  //     child: AlertDialog(
  //       title: Text("Account Optionen"),
  //       content: Container(
  //         child: Column(
  //           children: <Widget>[
  //             FlatButton(
  //               child: Text("Account löschen"),

  //               // onPressed: () {
  //               //   showDialog(
  //               //     context: context,
  //               //     child: AlertDialog(
  //               //       title: Text("Bestätigung"),
  //               //       content: Container(
  //               //         child: Row(
  //               //           children: <Widget>[
  //               //             FlatButton(
  //               //               child: Text("Abbrechen"),
  //               //               onPressed: () => Navigator.pop(context),
  //               //             ),
  //               //             FlatButton(
  //               //               child: Text("Ok"),
  //               //               onPressed: () async {
  //               //                 // deletes Account from FirebaseAuth
  //               //                 _authenticationBloc.authenticationService
  //               //                     .deleteAccount();
  //               //                 String usernameInFunction = await _gameBloc
  //               //                     .cloudFirestoreDatabase
  //               //                     .getUsernameForUserID(
  //               //                         userID: _gameBloc.currentUserID);
  //               //                 // deletes Account Info from CloudFirestore
  //               //                 _gameBloc.cloudFirestoreDatabase
  //               //                     .deleteUserFromFirestore(
  //               //                         userID: _gameBloc.currentUserID,
  //               //                         username: usernameInFunction);
  //               //                 Navigator.pop(context);
  //               //                 Navigator.pop(context);
  //               //               },
  //               //             ),
  //               //           ],
  //               //         ),
  //               //       ),
  //               //     ),
  //               //   );
  //               // },
  //             ),
  //             FlatButton(
  //               child: Text("Passwort zurücksetzen"),
  //               onPressed: () {
  //                 _authenticationBloc.authenticationService
  //                     .sendResetPasswortEmail();
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Datenschutzerklärung"),
  //               onPressed: () {},
  //             ),
  //             Row(
  //               children: <Widget>[
  //                 FlatButton(
  //                   child: Text("Abbrechen"),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(""),
            ),
          ),
          // display some basic information (number of games, number of wins, number of moves) instead
          //
          // DrawerHeader(
          //   child: Column(
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           GestureDetector(
          //             child: CircleAvatar(),
          //             onTap: () => showUserOptionsDialog(),
          //           ),
          //           Text("Benutzername: $username"),
          //         ],
          //       ),
          //       Text("Email: $emailAdress"),
          //       FlatButton(
          //         child: Text("werde Normal"),
          //         onPressed: () async {
          //           SharedPreferences sharedPreferences =
          //               await SharedPreferences.getInstance();
          //           sharedPreferences.setBool("isUserPremium", false);
          //           this._authenticationBloc.isUserPremiumSink.add(false);
          //         },
          //       )
          //     ],
          //   ),
          // ),
          ListTile(
            title: Text(
              "Partien",
              style: theme.textTheme.headline6,
            ),
            // black white chess board icon
            leading: Image.asset(
              "assets/images/black_white_board.png",
              width: theme.iconTheme.size * 0.9,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Freunde",
              style: theme.textTheme.headline6,
            ),
            leading: Icon(
              Icons.group,
              color: theme.iconTheme.color,
            ),
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
            title: Text(
              "Einstellungen",
              style: theme.textTheme.headline6,
            ),
            leading: Icon(
              Icons.settings,
              color: theme.iconTheme.color,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: false,
                      builder: (BuildContext context) {
                        return SettingsPremium(
                          username: this.username,
                          emailAdress: this.emailAdress,
                        );
                      }));
            },
          ),
          ListTile(
            title: Text(
              "Über",
              style: theme.textTheme.headline6,
            ),
            leading: Icon(
              Icons.info_outline,
              color: theme.iconTheme.color,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (BuildContext context) {
                      return About();
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
