// home.dart
import "../imports.dart";

// TODO: machen, dass die Partien auch gesichert werden, wenn man die App schließt
// TODO: add ability to delete account
// TODO: add routes to MaterialApp and make everything Navigator.pushNamed
// TODO: add the sources for the app icon to the "about" page

class Home extends StatefulWidget {
  List<PartieKlasse> partien = [];
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

  // TODO: create invitations
  @override
  Widget build(BuildContext context) {
    print("gameBloc games " + _gameBloc.games.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("JustChess"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () {
              _gameBloc.refresh();
            },
          )
        ],
      ),
      floatingActionButton: PartieErstellenButton(
        gameBloc: this._gameBloc,
      ),
      drawer: Menu(),
      body: SafeArea(
        child: StreamBuilder(
            initialData: [],
            stream: _gameBloc.gamesListStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null ||
                  snapshot.data == [] ||
                  snapshot.data.isEmpty) {
                return Center(
                  child: Text("Noch keine Partien hinzugefügt"),
                );
              } else {
                return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(
                          snapshot.data[index].id,
                        ),
                        child: ListTile(
                          title: Text(snapshot.data[index].name ?? ""),
                          subtitle: Text(
                              "Anzahl der Züge: ${snapshot.data[index].moveCount.toString()}"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: false,
                                builder: (context) => Partie(
                                  aktuellePartie: snapshot.data[index],
                                  gameBloc: _gameBloc,
                                ),
                              ),
                            );
                          },
                        ),
                        background: Icon(Icons.delete),
                        secondaryBackground: Icon(Icons.delete),
                        onDismissed: (direction) => setState(() {
                          _gameBloc.deleteGameSink.add(snapshot.data[index]);
                        }),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: snapshot.data.length);
              }
            }),
      ),
    );
  }
}
