// homePremium.dart
import "../../../imports.dart";

// TODO: clean everything up, split some widgets up and improve performance

// TODO: add ability to delete account
// TODO: add routes to MaterialApp and make everything Navigator.pushNamed
// TODO: add the sources for the app icon to the "about" page

// bigger projects:
// TODO: add offline support
// TODO: add in app purchases
// TODO: add starter tutorial
class HomePremium extends StatefulWidget {
  @override
  _HomePremiumState createState() => _HomePremiumState();
}

// WidgetsBindingObserver helps observing the AppLifecycleState (to refresh _gamesBloc when app is resumed)
class _HomePremiumState extends State<HomePremium> with WidgetsBindingObserver {
  GamesBloc _gamesBloc;
  AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      this._appLifecycleState = state;
    });
  }

  // this has to be like this; onRefresh has to get a value
  Future<void> refresh() async {
    _gamesBloc.refresh();
  }

  // TODO: create invitations
  @override
  Widget build(BuildContext context) {
    if (_appLifecycleState?.index == 0) {
      refresh();
    }

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "JustChess",
        ),
        textTheme: theme.appBarTheme.textTheme,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.local_post_office),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (BuildContext context) {
                      return Invitations();
                    }),
              );
            },
          ),
        ],
      ),
      floatingActionButton: CreateGameButton(
        isUserPremium: true,
      ),
      drawer: MenuPremium(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => refresh(),
          child: StreamBuilder(
              initialData: _gamesBloc.gamesList,
              stream: _gamesBloc.gamesListStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // has to be scrollable (to enable pull to refresh)
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
                  // has to be scrollable (to enable pull to refresh)
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
                  return Scrollbar(
                    child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          // current Game
                          GameClass currentGame = snapshot.data[index];

                          bool userWhite() {
                            if (currentGame.player01IsWhite &&
                                _gamesBloc.currentUserID ==
                                    currentGame.player01) {
                              return true;
                            } else if (!currentGame.player01IsWhite &&
                                _gamesBloc.currentUserID ==
                                    currentGame.player02) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          bool isUserWhite = userWhite();
                          bool usersTurn() {
                            if (currentGame.whitesTurn && isUserWhite) {
                              return true;
                            } else if (!currentGame.whitesTurn &&
                                !isUserWhite) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          bool isUsersTurn = usersTurn();

                          return Column(
                            children: <Widget>[
                              Container(
                                color:
                                    isUsersTurn ? theme.indicatorColor : null,
                                child: Dismissible(
                                    key: Key(
                                      currentGame.id,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        _gamesBloc.gameTitlesList[index] ?? "",
                                        style: theme.textTheme.headline6,
                                      ),
                                      subtitle: Text(
                                        currentGame.player02.isEmpty
                                            ? "Anzahl der Züge: " +
                                                currentGame.moveCount.toString()
                                            : "Anzahl der Züge: " +
                                                    currentGame.moveCount
                                                        .toString() +
                                                    ", " +
                                                    currentGame.title ??
                                                "",
                                        style: theme.textTheme.subtitle1,
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: theme.iconTheme.color,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              fullscreenDialog: false,
                                              builder: (context) {
                                                if (currentGame
                                                        .player02.isEmpty ||
                                                    currentGame.player02 ==
                                                        null) {
                                                  return Game(
                                                    game: currentGame,
                                                    isUserPremium: true,
                                                  );
                                                } else {
                                                  return GamePremium(
                                                    currentGame: currentGame,
                                                    opponentsName: _gamesBloc
                                                        .gameTitlesList[index],
                                                    isUserWhite: isUserWhite,
                                                  );
                                                }
                                              }),
                                        );
                                      },
                                    ),
                                    background: Icon(
                                      Icons.delete,
                                      color: theme.iconTheme.color,
                                    ),
                                    secondaryBackground: Icon(
                                      Icons.delete,
                                      color: theme.iconTheme.color,
                                    ),
                                    confirmDismiss: (_) async {
                                      bool confirmed;

                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Löschen bestätigen"),
                                              content: Text(
                                                  "Willst du diese Partie wirklich löschen? Diese Aktion kann nicht widerrufen werden!"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "Bestätigen",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    confirmed = true;
                                                    // has to be here (showDialog finishes only when the dialog gets popped)
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                    child: Text("Abbrechen"),
                                                    onPressed: () {
                                                      confirmed = false;
                                                      // has to be here (showDialog finishes only when the dialog gets popped)
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            );
                                          });
                                      return confirmed;
                                    },
                                    onDismissed: (direction) {
                                      print("dismissed");
                                      setState(() {
                                        _gamesBloc.deleteGameSink
                                            .add(currentGame);
                                      });
                                    }),
                              ),
                              Divider(),
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
