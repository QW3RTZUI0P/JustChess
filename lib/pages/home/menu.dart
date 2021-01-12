// menuPremium.dart
import "package:flutter/material.dart";
import "package:JustChess/widgets/theme.dart";
import "package:JustChess/services/cloudFirestoreDatabase.dart";
import "package:JustChess/blocs/authenticationBloc.dart";
import "package:JustChess/blocs/gamesBloc.dart";
import "package:JustChess/pages/settings.dart";
import "package:JustChess/pages/friends/friends.dart";
import "package:JustChess/pages/about.dart";

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
              child: Column(
          children: <Widget>[
            //TODO: display some basic information (number of games, number of wins, number of moves) instead

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
            Divider(),

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
            Divider(),

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
                          return Settings(
                            username: this.username,
                            emailAdress: this.emailAdress,
                          );
                        }));
              },
            ),
            Divider(),
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
            Divider(),
          ],
        ),
      ),
    );
  }
}
