// menu.dart
import "../../../imports.dart";

class Menu extends StatelessWidget {
  AuthenticationBloc authenticationBloc;
  Menu({@required this.authenticationBloc});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Row(
                children: <Widget>[
                  Icon(Icons.star, color: Colors.yellow.shade600),
                  FlatButton(
                    child: Text("werde Premium"),
                    onPressed: () async {
                      // makes the user to a premium user
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setBool("isUserPremium", true);
                      authenticationBloc.isUserPremiumSink.add(true);
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Partien"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text("Einstellungen"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (BuildContext context) {
                      return Settings();
                    }),
              );
            },
          ),
          // TODO: think about putting this at the bottom of the menu
          ListTile(
            title: Text("Über"),
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
