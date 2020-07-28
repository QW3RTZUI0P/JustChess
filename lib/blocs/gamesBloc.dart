// gamesBloc.dart
import "../imports.dart";
import "dart:convert";

class GamesBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  // userUID of the current logged in user
  String currentUserID = "";
  // list of the current user's games (offline and online games)
  List<GameClass> gamesList = [];
  // list with the gameIDs of the logged in user (from the current user's user document)
  List<String> gameIDsList = [];
  // list with the names/titles of the games
  // - the user-given name in an offline game
  // - the opponent's name in an online game
  List<String> gameTitlesList = [];
  // list of the local games (for saving to the local file system)
  List<GameClass> localGamesList = [];

  //
  // StreamControllers:
  // StreamController that controls all the gameIDs of the current user
  final StreamController<String> gameIDController = StreamController<String>();
  Sink<String> get gameIDSink => gameIDController.sink;
  Stream<String> get gameIDStream => gameIDController.stream;

  // StreamController that controls all the games being fetched from Firebase
  final StreamController<GameClass> fetchedGameController =
      StreamController<GameClass>();
  Sink<GameClass> get fetchedGameSink => fetchedGameController.sink;
  Stream<GameClass> get fetchedGameStream => fetchedGameController.stream;

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

  // controls the deleted games
  final StreamController<GameClass> deleteGameController =
      StreamController<GameClass>();
  Sink<GameClass> get deleteGameSink => deleteGameController.sink;
  Stream<GameClass> get deleteGameStream => deleteGameController.stream;

  // StreamController which contains all the users games
  final StreamController<List<GameClass>> gamesListController =
      StreamController<List<GameClass>>.broadcast();
  Sink<List<GameClass>> get gamesListSink => gamesListController.sink;
  Stream<List<GameClass>> get gamesListStream => gamesListController.stream;

  // constructor
  GamesBloc({
    this.cloudFirestoreDatabase,
    this.authenticationService,
  }) {
    _startListeners();
    getGamesAndImportantValues();
  }

  // starts the listeners for the three streams
  void _startListeners() async {
    this.gameIDStream.listen((gameID) async {
      // adds gameID locally
      this.gameIDsList.add(gameID);
      GameClass currentGameInFunction =
          await cloudFirestoreDatabase.getGameFromFirestore(gameID: gameID);
      this.fetchedGameSink.add(currentGameInFunction);
    });
    this.fetchedGameStream.listen((game) async {
      // updates the opponents name list (has to be before this.games is added to gamesListSink)
      String opponentsUserID =
          (game.player01 == currentUserID) ? game.player02 : game.player01;
      String opponentsName = await cloudFirestoreDatabase.getUsernameForUserID(
          userID: opponentsUserID);
      this.gameTitlesList.add("Partie gegen " + opponentsName);
      // adds game locally
      this.gamesList.add(game);
      // adds updated gamesList to the gamesListStream
      this.gamesListSink.add(this.gamesList);
    });

    // is being executed when the user adds a game (local or online)
    // not when the games are being fetched from Firebase and not when the user accepts an invitation
    this.addGameStream.listen((addedGame) {
      // executes when the game is offline
      if (addedGame.player02.isEmpty ||
          addedGame.player02 == null ||
          addedGame.player02 == "") {
        this.gamesList.add(addedGame);
        this.localGamesList.add(addedGame);
        this.gameTitlesList.add(addedGame.title);
        this.gamesListSink.add(this.gamesList);
        LocalDatabaseFileRoutines().writeFile(
          jsonString: gamesListToJsonString(this.localGamesList),
        );
      }
      // executes when the game is online
      else {
        // adds values locally to this class
        this.gameIDsList.add(addedGame.id);
        this.fetchedGameSink.add(addedGame);
        // adds values to Firebase
        // adds the gameID to the first player
        this.cloudFirestoreDatabase.addGameIDToFirestore(
            userID: addedGame.player01, gameID: addedGame.id);
        // adds the gameID to the second player
        this.cloudFirestoreDatabase.addGameIDToFirestore(
            userID: addedGame.player02, gameID: addedGame.id);
        // adds the game object to the games collection
        this.cloudFirestoreDatabase.addGameToFirestore(game: addedGame);
      }
    });
    this.updateGameStream.listen((updatedGame) async {
      int index = this.gamesList.indexWhere(
          (GameClass outdatedGame) => outdatedGame.id == updatedGame.id);
      // updates this.games with updatedGame
      this.gamesList.replaceRange(index, index + 1, [updatedGame]);
      // executes when the game is offline
      if (updatedGame.player02.isEmpty || updatedGame.player02 == null) {
        int indexInIf = this.localGamesList.indexWhere(
            (GameClass outdatedGame) => outdatedGame.id == updatedGame.id);
        this
            .localGamesList
            .replaceRange(indexInIf, indexInIf + 1, [updatedGame]);
        LocalDatabaseFileRoutines().writeFile(
          jsonString: gamesListToJsonString(this.localGamesList),
        );
      }
      // executes when the game is online
      else {
        cloudFirestoreDatabase.updateGameFromFirestore(game: updatedGame);
      }
      // adds the updated list to gamesListSink
      this.gamesListSink.add(this.gamesList);
    });
    this.deleteGameStream.listen((deletedGame) {
      // executes when the game is offline
      if (deletedGame.player02.isEmpty ||
          deletedGame.player02 == "" ||
          deletedGame.player02 == null) {
        // deletes the entry in the opponentsNamesList
        this.gameTitlesList.removeAt(this.gamesList.indexOf(deletedGame));
        // deletes the game locally
        this.gamesList.remove(deletedGame);
        this.localGamesList.remove(deletedGame);
        this.gamesListSink.add(this.gamesList);
        // removes game locally
        LocalDatabaseFileRoutines().writeFile(
          jsonString: gamesListToJsonString(this.localGamesList),
        );
      }
      // executes when the game is online
      else {
        // executed when the game can be deleted in Firebase
        if (deletedGame.canBeDeleted) {
          // deletes the entry in the opponentsNamesList
          this.gameTitlesList.removeAt(this.gamesList.indexOf(deletedGame));
          // deletes the game locally
          this.gamesList.remove(deletedGame);
          this.gamesListSink.add(this.gamesList);
          // deletes game in Firebase
          cloudFirestoreDatabase.deleteGameFromFirestore(
              gameID: deletedGame.id);
          cloudFirestoreDatabase.deleteGameIDFromFirestore(
              userID: currentUserID, gameID: deletedGame.id);
        } else {
          GameClass changedGame = GameClass.from(deletedGame);
          changedGame.canBeDeleted = true;
          // updates the canBeDeleted value of this game object to true
          cloudFirestoreDatabase.updateGameFromFirestore(game: changedGame);
          // deletes gameID in the users object
          cloudFirestoreDatabase.deleteGameIDFromFirestore(
              userID: currentUserID, gameID: deletedGame.id);

          // deletes the entry in the opponentsNamesList
          this.gameTitlesList.removeAt(this.gamesList.indexOf(deletedGame));

          this.gamesList.remove(deletedGame);
          this.gamesListSink.add(this.gamesList);
        }
      }
    });
  }

  // gets all the important values to function this class
  void getGamesAndImportantValues() async {
    // only executes when the user is signed in
    if (await authenticationService.currentUser() != null) {
      // userID of the current user
      this.currentUserID = await authenticationService.currentUserUid();
      // fetches the gameIDs from CloudFirestore
      List<dynamic> gameIDsInFunction = await cloudFirestoreDatabase
              .getGameIDsFromFirestore(userID: this.currentUserID) ??
          [];
      // if the user hasn't any gameIDs (or any local games) the for loop wouldn't execute and gamesListSink wouldn't get anything
      if (gameIDsInFunction.length == 0 || gameIDsInFunction.isEmpty) {
        this.gamesListSink.add(this.gamesList);
      }
      // adds each gameID to the gameIDSink, which passes it down the Stream Tree
      for (String currentGameID in gameIDsInFunction) {
        gameIDSink.add(currentGameID);
      }
    }

    // fetches the games from the local file system
    String jsonString = await LocalDatabaseFileRoutines().readFileAsString();
    this.localGamesList = gamesListFromJsonString(jsonString);
    // adds something to the gamesListSink Stream (otherwise the snapshot wouldn't get anything because the for loop wouldn't execute)
    if (this.localGamesList.isEmpty) {
      this.gamesListSink.add(this.gamesList);
    }
    // adds each local game to gamesListSink
    for (GameClass currentGame in this.localGamesList) {
      this.gamesList.add(currentGame);
      this.gameTitlesList.add(currentGame.title);
      gamesListSink.add(this.gamesList);
    }
  }

  // refreshes, reloads and refetches the list of games from Firebase
  void refresh() {
    gamesList.clear();
    localGamesList.clear();
    gameTitlesList.clear();
    getGamesAndImportantValues();
  }

  // resets everything
  void signOut() {
    this.gameIDsList.clear();
    this.gamesList.clear();
    this.gameTitlesList.clear();
    this.currentUserID = "";
    // signs the user out (in Firebase Auth)
    this.authenticationService.signOut();
  }

  // closes all of the StreamControllers to preserve performance
  void dispose() {
    gameIDController.close();
    fetchedGameController.close();
    addGameController.close();
    updateGameController.close();
    deleteGameController.close();
    gamesListController.close();
  }
}

// provider for the GamesBloc
class GamesBlocProvider extends InheritedWidget {
  final GamesBloc gamesBloc;
  const GamesBlocProvider({Key key, Widget child, this.gamesBloc})
      : super(key: key, child: child);
  static GamesBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GamesBlocProvider>();
  }

  @override
  bool updateShouldNotify(GamesBlocProvider oldWidget) {
    // gibt nur true aus, wenn sich die beiden blocs unterscheiden
    return this.gamesBloc != oldWidget.gamesBloc;
  }
}
