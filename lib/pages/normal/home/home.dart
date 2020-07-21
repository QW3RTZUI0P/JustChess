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
    print("games " + _localGamesBloc.database.games.toString());
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
                    return Column(
                      children: <Widget>[
                        Dismissible(
                          key: Key(
                            snapshot.data[index].id,
                          ),
                          child: ListTile(
                            title: Text(snapshot.data[index].subtitle),
                            subtitle: Text("Anzahl der Züge: " +
                                snapshot.data[index].moveCount.toString()),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) {
                                        return Game(
                                          game: snapshot.data[index],
                                        );
                                      }));
                            },
                          ),
                          background: Container(
                            child: Icon(Icons.delete),
                          ),
                          onDismissed: (_) {
                            _localGamesBloc.localGameDeleted(
                                deletedGame: snapshot.data[index]);
                          },
                        ),
                        Container(
                          height: 1.0,
                          color: Colors.grey,
                        ),
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
