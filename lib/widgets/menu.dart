// menu.dart
import "../imports.dart";

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
          )
        ],
      ),
    );
  }
}
