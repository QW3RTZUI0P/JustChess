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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Text("Benutzername: $username"),
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
              _gameBloc.games.clear();
              _gameBloc.currentUserID = "";

              _authenticationBloc.authenticationService.signOut();
            },
          ),
        ],
      ),
    );
  }
}
