// localGamesBloc.dart
import "../imports.dart";
import "dart:convert";

// TODO: remove database Class and use instead only a list<GameClass>

class LocalGamesBloc {
  List<GameClass> gamesList = [];

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
    List<GameClass> gamesListInFunction = gamesListFromJsonString(jsonString);
    // LocalDatabase databaseInFunction =
    //     LocalDatabase.fromJson(jsonDecode(jsonString ?? "") ?? {});
    if (gamesListInFunction.isEmpty) {
      gamesListSink.add([]);
      return;
    }
    for (GameClass currentGame in gamesListInFunction) {
      addGameSink.add(currentGame);
    }
    // print(jsonDecode(jsonString));
    // print(await LocalDatabaseFileRoutines().readFileAsString());
  }

  void _startListeners() {
    this.addGameStream.listen((addedGame) {
      // adds the game to the games list in the database object
      this.gamesList.add(addedGame);
      // adds the updated games list from the database to GamesListStream
      this.gamesListSink.add(this.gamesList);
    });
  }

  void dispose() {
    addGameController.close();
    gamesListController.close();
  }

  // gets called when a game is created
  void localGameCreated({GameClass newGame}) {
    this.gamesList.add(newGame);
    this.gamesListSink.add(this.gamesList);
    LocalDatabaseFileRoutines().writeFile(
      jsonString: gamesListToJsonString(this.gamesList),
    );
  }

  // gets called when a game is updated
  void localGameUpdated({GameClass updatedGame}) {
    int index =
        this.gamesList.indexWhere((oldGame) => oldGame.id == updatedGame.id);
    this.gamesList.replaceRange(index, index + 1, [updatedGame]);
    this.gamesListSink.add(this.gamesList);
    LocalDatabaseFileRoutines().writeFile(
      jsonString: gamesListToJsonString(this.gamesList),
    );
  }

  // gets called when a game is deleted
  void localGameDeleted({GameClass deletedGame}) async {
    this.gamesList.remove(deletedGame);
    this.gamesListSink.add(this.gamesList);
    LocalDatabaseFileRoutines().writeFile(
      jsonString: gamesListToJsonString(this.gamesList),
    );
  }
}

class LocalGamesBlocProvider extends InheritedWidget {
  final LocalGamesBloc localGamesBloc;
  LocalGamesBlocProvider({
    Key key,
    Widget child,
    this.localGamesBloc,
  }) : super(key: key, child: child) {}
  static LocalGamesBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocalGamesBlocProvider>();
  }

  @override
  bool updateShouldNotify(LocalGamesBlocProvider oldWidget) {
    return this.localGamesBloc != oldWidget.localGamesBloc;
  }
}
