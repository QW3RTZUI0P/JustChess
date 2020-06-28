// gameBloc.dart
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

import "../imports.dart";

class GameBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;
  GameBloc({
    this.cloudFirestoreDatabase,
    this.authenticationService,
  }) {
    print("gameBloc Constructor");
    _startListeners();
    getImportantValues();
  }

  String currentUserID = "";
  List<String> gameIDs = [];
  final StreamController<List<PartieKlasse>> gamesController =
      StreamController<List<PartieKlasse>>();
  Sink<List<PartieKlasse>> get _addGames => gamesController.sink;
  Stream<List<PartieKlasse>> get games => gamesController.stream;

  void getImportantValues() async {
    this.currentUserID = await authenticationService.currentUserUid();
    // this.gameIDs = await cloudFirestoreDatabase.getGameIDs().first;
    // anstatt dem hier müssten hier die richtigen Werte aus der Datenbank überschrieben werden
    this.gameIDs = ["kt0YubQK8yeaRz5GdzkjCYBRgiD21593335200147", "kt0YubQK8yeaRz5GdzkjCYBRgiD21593335574246",];
    _getGamesList();
  }

  void addGame({PartieKlasse game}) async {
    game.erstelleID();
    cloudFirestoreDatabase.addGame(game: game);
    cloudFirestoreDatabase.addGameID(gameID: game.id, userID: this.currentUserID,);
  }

  void _getGamesList() async {
    List<PartieKlasse> gamesList = [];
    for (String currentID in gameIDs) {
      print(currentID);
      gamesList.add(await cloudFirestoreDatabase.getGame(gameID: currentID));
    }
    print(gamesList.toString() + "gamesList");
    _addGames.add(gamesList);
  }

  void _startListeners() async {
    cloudFirestoreDatabase.getGameIDs().listen((newListOfIDs) async {
      // handleGames(newListOfIDs);
    });
  }

  void handleGames(List<String> newListOfIDs) async {
      List<PartieKlasse> oldGames = await games.first;
      if (this.gameIDs == newListOfIDs) {
        return;
      } else {
        List<PartieKlasse> onlyNewGames = [];
        // überprüft ob neue Partien hinzugekommen sind
        for (String currentNewID in newListOfIDs) {
          if (this.gameIDs.contains(currentNewID)) {
            return;
          } else {
            onlyNewGames.add(
                await cloudFirestoreDatabase.getGame(gameID: currentNewID));
          }
          List<PartieKlasse> newGames = oldGames + onlyNewGames;
          _addGames.add(newGames);
        }
        // überprüft ob Partien gelöscht wurden
        for (String currentNewID in gameIDs) {
          if (newListOfIDs.contains(currentNewID)) {
            return;
          } else {
            // game muss noch gelöscht werden
          }
        }
        this.gameIDs = newListOfIDs;
      }
  }

  void dispose() {
    gamesController.close();
  }
}

class GameBlocProvider extends InheritedWidget {
  final GameBloc gameBloc;
  const GameBlocProvider({Key key, Widget child, this.gameBloc})
      : super(key: key, child: child);
  static GameBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameBlocProvider>();
  }

  @override
  bool updateShouldNotify(GameBlocProvider oldWidget) {
    // gibt nur true aus, wenn sich die beiden blocs unterscheiden
    return this.gameBloc != oldWidget.gameBloc;
  }
}
