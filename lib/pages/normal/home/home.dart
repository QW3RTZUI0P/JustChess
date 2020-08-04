// home.dart
import "../../../imports.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LocalGamesBloc _localGamesBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._localGamesBloc = LocalGamesBlocProvider.of(context).localGamesBloc;
    this._authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
  }

  @override
  void dispose() {
    super.dispose();
    _localGamesBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("home build");
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        textTheme: theme.appBarTheme.textTheme,
      ),
      floatingActionButton: CreateGameButton(
        isUserPremium: false,
      ),
      drawer: Menu(
        authenticationBloc: this._authenticationBloc,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: _localGamesBloc.gamesListStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.isEmpty) {
                return Center(
                  child: Text("Noch keine Partien hinzugefügt"),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    GameClass currentGame = snapshot.data[index];
                    print(currentGame.id);
                    return Column(
                      children: <Widget>[
                        Dismissible(
                          key: Key(
                            currentGame.id,
                          ),
                          child: ListTile(
                            title: Text(
                              currentGame.title,
                              style: theme.textTheme.headline6,
                            ),
                            subtitle: Text(
                              "Anzahl der Züge: " +
                                  currentGame.moveCount.toString(),
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
                                      builder: (BuildContext context) {
                                        return Game(
                                          game: currentGame,
                                          isUserPremium: false,
                                        );
                                      }));
                            },
                          ),
                          background: Container(
                            child: Icon(Icons.delete),
                          ),
                          confirmDismiss: (_) => showDialog(
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
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        return true;
                                      },
                                    ),
                                    FlatButton(
                                        child: Text("Abbrechen"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          return false;
                                        }),
                                  ],
                                );
                              }),
                          onDismissed: (_) {
                            print(currentGame.id);
                            _localGamesBloc.localGameDeleted(
                                deletedGame: currentGame);
                          },
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
