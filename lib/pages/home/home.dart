// home.dart
import "../../imports.dart";

// TODO: clean everything up, split some widgets up and improve performance

// TODO: machen, dass die Partien auch gesichert werden, wenn man die App schließt
// TODO: add ability to delete account
// TODO: add routes to MaterialApp and make everything Navigator.pushNamed
// TODO: add the sources for the app icon to the "about" page
// TODO: add a coloured background to every ListTile with a game in which it's my turn

// bigger projects:
// TODO: add offline support
// TODO: add in app purchases
// TODO: add in app messaging
// TODO: add starter tutorial
class Home extends StatefulWidget {
  List<GameClass> partien = [];
  var partieGeloescht;
  Home({
    this.partien = const [],
    this.partieGeloescht,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationBloc _authenticationBloc;
  GameBloc _gameBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // this has to be like this; onRefresh has to get a value
  Future<void> refresh() async {
    _gameBloc.refresh();
  }

  // TODO: create invitations
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "JustChess",
          style: theme.textTheme.headline6,
        ),
      ),
      floatingActionButton: CreateGameButton(
        gameBloc: this._gameBloc,
      ),
      drawer: Menu(),
      body: SafeArea(
        // TODO: enable pull to reload also for CircularProgressIndicator and for "Noch keine Partien"
        child: RefreshIndicator(
          onRefresh: () => refresh(),
          child: StreamBuilder(
              initialData: [],
              stream: _gameBloc.gamesListStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.data == [] || snapshot.data.isEmpty) {
                  return ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text("Noch keine Partien hinzugefügt"),
                        ),
                      ),
                    ],
                  );
                } else {
                  List games = List.from(snapshot.data);

                  // games.sort((firstGame, secondGame) {
                  //   bool isWhite = (firstGame.player01IsWhite &&
                  //               firstGame.player01 ==
                  //                   _gameBloc.currentUserID) ||
                  //           (!firstGame.player01IsWhite ||
                  //               firstGame.player02 == _gameBloc.currentUserID)
                  //       ? true
                  //       : false;
                  //   bool isTurn = (firstGame.whitesTurn && isWhite) ||
                  //           (!firstGame.whitesTurn && !isWhite)
                  //       ? true
                  //       : false;
                  //   if (isTurn) {
                  //     return 1;
                  //   } else {
                  //     return -1;
                  //   }
                  // });
                  // for (GameClass game in games) {
                  //   print(game.subtitle);
                  //   print(game.whitesTurn.toString());
                  //   print("for");
                  // }
                  return Scrollbar(
                    child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          bool userWhite() {
                            if (snapshot.data[index].player01IsWhite &&
                                _gameBloc.currentUserID ==
                                    snapshot.data[index].player01) {
                              return true;
                            } else if (!snapshot.data[index].player01IsWhite &&
                                _gameBloc.currentUserID ==
                                    snapshot.data[index].player02) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          bool isUserWhite = userWhite();
                          bool usersTurn() {
                            if (snapshot.data[index].whitesTurn &&
                                isUserWhite) {
                              return true;
                            } else if (!snapshot.data[index].whitesTurn &&
                                !isUserWhite) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          bool isUsersTurn = usersTurn();
                          // print("home " +
                          //     isUsersTurn.toString() +
                          //     isUserWhite.toString() +
                          //     "whitesTurn" +
                          //     snapshot.data[index].whitesTurn.toString());
                          return Column(
                            children: <Widget>[
                              Container(
                                decoration: isUsersTurn
                                    ? BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.lightGreen.shade100,
                                            Colors.lightGreen.shade200,
                                            Colors.lightGreen.shade100,
                                          ],
                                        ),
                                      )
                                    : null,
                                child: Dismissible(
                                  key: Key(
                                    snapshot.data[index].id,
                                  ),
                                  child: ListTile(
                                    title: Text("Partie gegen " +
                                            _gameBloc
                                                .opponentsNamesList[index] ??
                                        ""),
                                    subtitle: Text(
                                        snapshot.data[index].subtitle ?? ""),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          fullscreenDialog: false,
                                          builder: (context) => Game(
                                            currentGame: snapshot.data[index],
                                            opponentsName: _gameBloc
                                                .opponentsNamesList[index],
                                            isUserWhite: isUserWhite,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  background: Icon(Icons.delete),
                                  secondaryBackground: Icon(Icons.delete),
                                  onDismissed: (direction) => setState(() {
                                    _gameBloc.deleteGameSink
                                        .add(snapshot.data[index]);
                                  }),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.data.length),
                  );
                }
              }),
        ),
      ),
    );
  }
}
