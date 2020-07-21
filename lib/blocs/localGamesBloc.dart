// localGamesBloc.dart
import "../imports.dart";
import "dart:convert";

// TODO: remove database Class and use instead only a list<GameClass>

class LocalGamesBloc {
  LocalDatabase database = LocalDatabase(games: []);

  StreamController<GameClass> addGameController = StreamController<GameClass>();
  Sink<GameClass> get addGameSink => addGameController.sink;
  Stream<GameClass> get addGameStream => addGameController.stream;

  StreamController<List<dynamic>> gamesListController =
      StreamController<List<dynamic>>();
  Sink<List<dynamic>> get gamesListSink => gamesListController.sink;
  Stream<List<dynamic>> get gamesListStream => gamesListController.stream;

  LocalGamesBloc() {
    _startListeners();
    getOfflineGames();
  }

  void getOfflineGames() async {
    String jsonString = await LocalDatabaseFileRoutines().readFileAsString();
    LocalDatabase databaseInFunction =
        LocalDatabase.fromJson(jsonDecode(jsonString ?? "") ?? {});
    if (databaseInFunction.games.isEmpty) {
      gamesListSink.add([]);
      return;
    }
    print("database games " + databaseInFunction.games[0].subtitle.toString());
    for (GameClass currentGame in databaseInFunction.games) {
      print("for");
      addGameSink.add(currentGame);
    }
    // print(jsonDecode(jsonString));
    // print(await LocalDatabaseFileRoutines().readFileAsString());
  }

  void _startListeners() {
    this.addGameStream.listen((addedGame) {
      // adds the game to the games list in the database object
      this.database.games.add(addedGame);
      // adds the updated games list from the database to GamesListStream
      this.gamesListSink.add(this.database.games);
    });
  }

  void dispose() {
    addGameController.close();
    gamesListController.close();
  }

  // gets called when a game is created
  void localGameCreated({GameClass newGame}) {
    this.database.games.add(newGame);
    this.gamesListSink.add(this.database.games);
    LocalDatabaseFileRoutines()
        .writeFile(jsonString: databaseToJson(this.database));
  }

  // gets called when a game is updated
  void localGameUpdated({GameClass updatedGame}) {
    int index = this
        .database
        .games
        .indexWhere((oldGame) => oldGame.id == updatedGame.id);
    this.database.games.replaceRange(index, index + 1, [updatedGame]);
    this.gamesListSink.add(this.database.games);
    LocalDatabaseFileRoutines().writeFile(
      jsonString: databaseToJson(this.database),
    );
  }

  // gets called when a game is deleted
  void localGameDeleted({GameClass deletedGame}) async {
    this.database.games.remove(deletedGame);
    this.gamesListSink.add(this.database.games);
    LocalDatabaseFileRoutines()
        .writeFile(jsonString: databaseToJson(this.database));
  }
}

class LocalGamesBlocProvider extends InheritedWidget {
  LocalGamesBloc localGamesBloc;
  LocalGamesBlocProvider({
    Key key,
    Widget child,
    this.localGamesBloc,
  }) : super(key: key, child: child);
  static LocalGamesBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocalGamesBlocProvider>();
  }

  @override
  bool updateShouldNotify(LocalGamesBlocProvider oldWidget) {
    return this.localGamesBloc != oldWidget.localGamesBloc;
  }
}
