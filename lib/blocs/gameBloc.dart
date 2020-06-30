// gameBloc.dart
import "../imports.dart";

class GameBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  // userUID of the current logged in user
  String currentUserID = "";
  // list of the current user's games
  List<PartieKlasse> games = [];
  // gameIDs of the logged in user (from the current user's document)
  List<String> gameIDs = [];

  // StreamController that controls all the gameIDs of the current user
  final StreamController<String> gameIDController = StreamController<String>();
  Sink<String> get gameIDSink => gameIDController.sink;
  Stream<String> get gameIDStream => gameIDController.stream;

  // StreamController that controls all the games being fetched from Firebase
  final StreamController<PartieKlasse> localGameController =
      StreamController<PartieKlasse>();
  Sink<PartieKlasse> get localGameSink => localGameController.sink;
  Stream<PartieKlasse> get localGameStream => localGameController.stream;

  // StreamController that controls all the games the user added (not the invitations the user accepted)
  final StreamController<PartieKlasse> addGameController =
      StreamController<PartieKlasse>();
  Sink<PartieKlasse> get addGameSink => addGameController.sink;
  Stream<PartieKlasse> get addGameStream => addGameController.stream;

  // controls the deleting of the games
  final StreamController<PartieKlasse> deleteGameController =
      StreamController<PartieKlasse>();
  Sink<PartieKlasse> get deleteGameSink => deleteGameController.sink;
  Stream<PartieKlasse> get deleteGameStream => deleteGameController.stream;

  final StreamController<List<PartieKlasse>> gamesListController =
      StreamController<List<PartieKlasse>>();
  Sink<List<PartieKlasse>> get gamesListSink => gamesListController.sink;
  Stream<List<PartieKlasse>> get gamesListStream => gamesListController.stream;

  GameBloc({
    this.cloudFirestoreDatabase,
    this.authenticationService,
  }) {
    _startListeners();
    getImportantValues();
  }

  // is executed in the constructor
  // gets all the important values to function this class
  void getImportantValues() async {
    this.currentUserID = await authenticationService.currentUserUid();
    print("currentUserID " + this.currentUserID);
    List<dynamic> gameIDs = await cloudFirestoreDatabase
            .getGameIDsFromFirestore(userID: this.currentUserID) ??
        [];
    for (String currentGameID in gameIDs) {
      gameIDSink.add(currentGameID);
    }
  }

  // starts the listeners for the three streams
  void _startListeners() async {
    this.gameIDStream.listen((gameID) async {
      // adds gameID locally
      this.gameIDs.add(gameID);
      PartieKlasse currentGame =
          await cloudFirestoreDatabase.getGameFromFirestore(gameID: gameID);
      this.localGameSink.add(currentGame);
    });
    this.localGameStream.listen((game) {
      // adds game locally
      this.games.add(game);
      // adds updated gamesList to the gamesListStream
      this.gamesListSink.add(this.games);
    });

    // is being executed when the user adds a game (not when the user accepts an invitation)
    this.addGameStream.listen((addedGame) {
      // adds values locally
      this.gameIDs.add(addedGame.id);
      this.localGameSink.add(addedGame);
      // adds values to Firebase
      this.cloudFirestoreDatabase.addGameIDToFirestore(
          userID: this.currentUserID, gameID: addedGame.id);
      this.cloudFirestoreDatabase.addGameToFirestore(game: addedGame);
    });
    // only .listen function that is smart
    this.deleteGameStream.listen((deletedGame) {
      print("id " + deletedGame.id);
      if (deletedGame.canBeDeleted) {
        // deletes the game locally
        this.games.remove(deletedGame);
        this.gamesListSink.add(this.games);
        // deletes game in Firebase
        cloudFirestoreDatabase.deleteGameFromFirestore(gameID: deletedGame.id);
        cloudFirestoreDatabase.deleteGameIDFromFirestore(
            userID: currentUserID, gameID: deletedGame.id);
        
      } else {
        PartieKlasse changedGame = deletedGame;
        changedGame.canBeDeleted = true;
        cloudFirestoreDatabase.updateGameFromFirestore(game: changedGame);
        // deletes gameID in the users object
        cloudFirestoreDatabase.deleteGameIDFromFirestore(
            userID: currentUserID, gameID: deletedGame.id);
      }
    });
  }

  // void _getGamesList() async {
  //   List<PartieKlasse> gamesList = [];
  //   for (String currentID in gameIDs) {
  //     print(currentID);
  //     gamesList.add(
  //         await cloudFirestoreDatabase.getGameFromFirestore(gameID: currentID));
  //   }
  //   print(gamesList.toString() + "gamesList");
  //   _addGames.add(gamesList);
  // }

  // void handleGames(List<String> newListOfIDs) async {
  //   List<PartieKlasse> oldGames = await games.first;
  //   if (this.gameIDs == newListOfIDs) {
  //     return;
  //   } else {
  //     List<PartieKlasse> onlyNewGames = [];
  //     // überprüft ob neue Partien hinzugekommen sind
  //     for (String currentNewID in newListOfIDs) {
  //       if (this.gameIDs.contains(currentNewID)) {
  //         return;
  //       } else {
  //         onlyNewGames.add(await cloudFirestoreDatabase.getGameFromFirestore(
  //             gameID: currentNewID));
  //       }
  //       List<PartieKlasse> newGames = oldGames + onlyNewGames;
  //       _addGames.add(newGames);
  //     }
  //     // überprüft ob Partien gelöscht wurden
  //     for (String currentNewID in gameIDs) {
  //       if (newListOfIDs.contains(currentNewID)) {
  //         return;
  //       } else {
  //         // game muss noch gelöscht werden
  //       }
  //     }
  //     this.gameIDs = newListOfIDs;
  //   }
  // }

  // closes all of the StreamControllers to preserve performance
  void dispose() {
    gameIDController.close();
    localGameController.close();
    addGameController.close();
    deleteGameController.close();
    gamesListController.close();
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
