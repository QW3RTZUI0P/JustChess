// menu.dart
import "../../../imports.dart";

class Menu extends StatelessWidget {
  AuthenticationBloc authenticationBloc;
  Menu({@required this.authenticationBloc});

  Future<void> _showGetPremiumScreen(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Card(
            child: Column(
              children: [
                Center(
                  child: Text("Hello"),
                ),
                RaisedButton(
                  child: Text("Premium kaufen"),
                  onPressed: () {
                    ProductDetails productDetails = ProductDetails(
                        id: "justchess_premium",
                        description: "JustChess Premium Abonnement",
                        price: "3.50€",
                        title: "JustChess Premium");
                    authenticationBloc.buyProduct(productDetails);
                  },
                ),
                RaisedButton(
                  child: Text("Schließen"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

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
                    child: Text("Werde Premium"),
                    onPressed: () async {
                      await _showGetPremiumScreen(context);
                      // // makes the user to a premium user
                      // SharedPreferences sharedPreferences =
                      //     await SharedPreferences.getInstance();
                      // sharedPreferences.setBool("isUserPremium", true);
                      // authenticationBloc.isUserPremiumSink.add(true);
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
