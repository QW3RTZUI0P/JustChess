// localGamesBloc.dart
import "../imports.dart";
import "dart:convert";

class LocalGamesBloc {
  LocalDatabase database = LocalDatabase();

  LocalGamesBloc() {
    getGames();
  }

  void getGames() async {
    String jsonString = await LocalDatabaseFileRoutines().readFileAsString();
    this.database = LocalDatabase.fromJson(jsonDecode(jsonString));
  }

  // gets called when a game is created
  void localGameCreated({GameClass newGame}) async {
    this.database.games.add(newGame);
    LocalDatabaseFileRoutines()
        .writeFile(jsonString: databaseToJson(this.database));
  }

  // gets called when a game is updated
  void localGameUpdated({GameClass updatedGame}) async {
    int index = this
        .database
        .games
        .indexWhere((oldGame) => oldGame.id == updatedGame.id);
    this.database.games.replaceRange(index, index + 1, [updatedGame]);
    LocalDatabaseFileRoutines().writeFile(
      jsonString: databaseToJson(this.database),
    );
  }

  // gets called when a game is deleted
  void localGameDeleted({GameClass deletedGame}) async {
    this.database.games.remove(deletedGame);
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
