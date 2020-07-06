// menu.dart
import "../imports.dart";

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  AuthenticationBloc authenticationBloc;
  GameBloc _gameBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text("Header"),
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
            title: Text("Ausloggen"),
            onTap: () async {
              _gameBloc.games.clear();
              _gameBloc.currentUserID = "";
              
              authenticationBloc.authenticationService.signOut();
            },
          ),
        ],
      ),
    );
  }
}
