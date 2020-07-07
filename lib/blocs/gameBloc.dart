// gameBloc.dart
import "../imports.dart";

class GameBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  // userUID of the current logged in user
  String currentUserID = "";
  // list of the current user's games
  List<GameClass> games = [];
  // gameIDs of the logged in user (from the current user's document)
  List<String> gameIDs = [];

  // StreamController that controls all the gameIDs of the current user
  final StreamController<String> gameIDController = StreamController<String>();
  Sink<String> get gameIDSink => gameIDController.sink;
  Stream<String> get gameIDStream => gameIDController.stream;

  // StreamController that controls all the games being fetched from Firebase
  final StreamController<GameClass> localGameController =
      StreamController<GameClass>();
  Sink<GameClass> get localGameSink => localGameController.sink;
  Stream<GameClass> get localGameStream => localGameController.stream;

  // StreamController that controls all the games the user added (not the invitations the user accepted)
  final StreamController<GameClass> addGameController =
      StreamController<GameClass>();
  Sink<GameClass> get addGameSink => addGameController.sink;
  Stream<GameClass> get addGameStream => addGameController.stream;

  // controls the updated games
  final StreamController<GameClass> updateGameController =
      StreamController<GameClass>();
  Sink<GameClass> get updateGameSink => updateGameController.sink;
  Stream<GameClass> get updateGameStream => updateGameController.stream;

  // controls the deleting of the games
  final StreamController<GameClass> deleteGameController =
      StreamController<GameClass>();
  Sink<GameClass> get deleteGameSink => deleteGameController.sink;
  Stream<GameClass> get deleteGameStream => deleteGameController.stream;

  final StreamController<List<GameClass>> gamesListController =
      StreamController<List<GameClass>>.broadcast();
  Sink<List<GameClass>> get gamesListSink => gamesListController.sink;
  Stream<List<GameClass>> get gamesListStream => gamesListController.stream;

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
    // if the user hasn't any gameIDs the for loop wouldn't execute and gamesListSink wouldn't get anything
    if (gameIDs.length == 0) {
      this.gamesListSink.add(this.games);
    }
    // adds each gameID to the gameIDSink, which passes it down the Stream Tree
    for (String currentGameID in gameIDs) {
      gameIDSink.add(currentGameID);
    }
  }

  // refreshes, reloads and refetches the list of games from Firebase
  Future<void> refresh() async {
    games.clear();
    this.currentUserID = await authenticationService.currentUserUid();
    List<dynamic> gameIDs = await cloudFirestoreDatabase
            .getGameIDsFromFirestore(userID: this.currentUserID) ??
        [];
    print("gameIDs: " + gameIDs.toString());
    for (String currentGameID in gameIDs) {
      gameIDSink.add(currentGameID);
    }
    return;
  }

  // starts the listeners for the three streams
  void _startListeners() async {
    this.gameIDStream.listen((gameID) async {
      // adds gameID locally
      this.gameIDs.add(gameID);
      GameClass currentGame =
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
          userID: addedGame.player01, gameID: addedGame.id);
      this.cloudFirestoreDatabase.addGameIDToFirestore(
          userID: addedGame.player02, gameID: addedGame.id);
      this.cloudFirestoreDatabase.addGameToFirestore(game: addedGame);
    });
    this.updateGameStream.listen((updatedGame) {
      GameClass outdatedGame =
          this.games.where((game) => game.id == updatedGame.id).elementAt(0);
      int index = this.games.indexOf(outdatedGame);
      this.games.replaceRange(index, index + 1, [updatedGame]);
      this.gamesListSink.add(this.games);
      cloudFirestoreDatabase.updateGameFromFirestore(game: updatedGame);
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
        GameClass changedGame = GameClass.from(deletedGame);
        changedGame.canBeDeleted = true;
        cloudFirestoreDatabase.updateGameFromFirestore(game: changedGame);
        // deletes gameID in the users object
        cloudFirestoreDatabase.deleteGameIDFromFirestore(
            userID: currentUserID, gameID: deletedGame.id);
        this.games.remove(deletedGame);
        this.gamesListSink.add(this.games);
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
    updateGameController.close();
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
