// home.dart
import "../../imports.dart";
import "dart:io";
// TODO: clean everything up, split some widgets up and improve performance

// TODO: add routes to MaterialApp and make everything Navigator.pushNamed
// TODO: add the sources for the app icon to the "about" page

// bigger projects:
// TODO: add in app purchases
// TODO: add starter tutorial
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// WidgetsBindingObserver helps observing the AppLifecycleState (to refresh _gamesBloc when app is resumed)
class _HomeState extends State<Home> with WidgetsBindingObserver {
  GamesBloc _gamesBloc;
  int _invitationsBadge;

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      refresh();
    }
  }

  // this has to be like this; onRefresh has to get a value
  Future<void> refresh() async {
    await _gamesBloc.refreshAll(updateInvitationsListStream: true);
    return;
  }

  Future<bool> _checkInternetConnection({BuildContext currentContext}) async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      // probably unnecessary
      else {
        SnackbarMessage(
            context: currentContext,
            message: "Nicht mit dem Internet verbunden");
        return false;
      }
    } on SocketException catch (error) {
      print(error.toString());
      SnackbarMessage(
          context: currentContext, message: "Nicht mit dem Internet verbunden");
      return false;
    } catch (error) {
      print(error.toString());
      SnackbarMessage(
        context: currentContext,
        message: error.toString(),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("building home");
    ThemeData theme = Theme.of(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    var appBar = AppBar(
      title: Text(
        "JustChess",
      ),
      textTheme: theme.appBarTheme.textTheme,
      actions: <Widget>[
        // TODO: move the notification badge to the right side (in release mode)
        StreamBuilder(
            stream: _gamesBloc.invitationsListStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.local_post_office),
                  tooltip: "Einladungen",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: false,
                          builder: (BuildContext context) {
                            return Invitations(
                              gamesBloc: this._gamesBloc,
                            );
                          }),
                    );
                  },
                );
              }
              return Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.local_post_office,
                      color: Colors.white,
                    ),
                    tooltip: "Einladungen",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (BuildContext context) {
                              return Invitations(
                                gamesBloc: this._gamesBloc,
                              );
                            }),
                      );
                    },
                  ),
                  // notification badge
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: theme.iconTheme.size * 0.7,
                        minHeight: theme.iconTheme.size * 0.7,
                        // minWidth: mediaQueryData.size.width * 0.049,
                        // minHeight: mediaQueryData.size.width * 0.049,
                      ),
                      child: Text(
                        snapshot.data.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }),
      ],
    );
    return Scaffold(
      appBar: appBar,
      floatingActionButton: CreateGameButton(),
      drawer: Menu(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (BuildContext currentContext) => RefreshIndicator(
            color: theme.primaryColor,
            onRefresh: () async {
              if (await _checkInternetConnection(
                  currentContext: currentContext)) {
                refresh();
              }
            },
            child: StreamBuilder(
                // initialData: _gamesBloc.gamesList,
                stream: _gamesBloc.gamesListStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data.isEmpty) {
                    // has to be scrollable (to enable pull to refresh)
                    return ListView(
                      children: [
                        Container(
                          height: mediaQueryData.size.height -
                              appBar.preferredSize.height -
                              mediaQueryData.padding.top -
                              mediaQueryData.padding.bottom,
                          child: Center(
                            // makes the indicator black
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.data == []) {
                    // has to be scrollable (to enable pull to refresh)
                    return ListView(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text(
                              "Noch keine Partien hinzugefügt",
                              style: theme.textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Scrollbar(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
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
                              // TODO: aminationen einbauen
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

                          // composes the right subtitle for the list tile
                          String gameSubtitle = "";
                          if (currentGame.player02.isEmpty ||
                              !currentGame.isOnline) {
                            gameSubtitle = "Anzahl der Züge: " +
                                currentGame.moveCount.toString();
                          } else {
                            gameSubtitle = "Anzahl der Züge: " +
                                currentGame.moveCount.toString();
                            if (currentGame.title != "") {
                              gameSubtitle += ", " + currentGame.title;
                            }
                          }

                          return Dismissible(
                              key: Key(
                                currentGame.id,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: isUsersTurn
                                        ? theme.indicatorColor
                                        : null,
                                    child: ListTile(
                                      title: Text(
                                        _gamesBloc.gameTitlesList[index] ?? "",
                                        style: theme.textTheme.headline5,
                                      ),
                                      subtitle: Text(gameSubtitle ?? "",
                                          style: theme.textTheme.subtitle1),
                                      // subtitle: Text(
                                      //   // checks whether the game is offline
                                      //   // TODO: remove .player02.isEmpty reference
                                      //   currentGame.player02.isEmpty ||
                                      //           !currentGame.isOnline
                                      //       ? "Anzahl der Züge: " +
                                      //           currentGame.moveCount.toString()
                                      //       : "Anzahl der Züge: " +
                                      //                   currentGame.moveCount
                                      //                       .toString() +
                                      //                   // checks whether the title of the online game is empty
                                      //                   currentGame.title ==
                                      //               ""
                                      //           ? " "
                                      //           : ", " + currentGame.title ??
                                      //               "",
                                      //   style: theme.textTheme.subtitle1,
                                      // ),
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
                                                    !currentGame.isOnline) {
                                                  return Game(
                                                    game: currentGame,
                                                  );
                                                } else {
                                                  return OnlineGame(
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
                                  ),
                                  Divider(),
                                ],
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
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                  _gamesBloc.deleteGameSink.add(currentGame);
                                });
                              });
                        },
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
