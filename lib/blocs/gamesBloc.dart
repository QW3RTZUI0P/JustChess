// gamesBloc.dart
import "../imports.dart";

class GamesBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  // userUID of the current logged in user
  String currentUserID = "";
  // list of the local games (for saving to the local file system)
  List<GameClass> localGamesList = [];
  // list with the gameIDs of the logged in user (from the current user's user document)
  List<String> gameIDsList = [];
  // list of the current user's games (offline and online games)
  List<GameClass> gamesList = [];

  // list with the names/titles of the games
  // - the user-given name in an offline game
  // - the opponent's name in an online game
  List<String> gameTitlesList = [];

  // list of the user's invitations (the ones he hasn't accepted yet)
  List<InvitationClass> invitationsList = [];

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

  // controls the user's invitations
  final StreamController<List<InvitationClass>> invitationsListController =
      StreamController<List<InvitationClass>>.broadcast();
  Sink<List<InvitationClass>> get invitationsListSink =>
      invitationsListController.sink;
  Stream<List<InvitationClass>> get invitationsListStream =>
      invitationsListController.stream;

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
      gameIDsList.add(gameID);
      // fetches game and passes it to fetchedGameStream
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
      // only executes for the last game
      if (game.id == gameIDsList.last) {
        print(game.id);
        // adds updated gamesList to the gamesListStream
        this.gamesListSink.add(this.gamesList);
      }
    });

    // is being executed when the user adds a game (local or online)
    // adds a game to gamesList and to several Sinks
    // adds an invitation to the user's opponent's user document
    // not when the games are being fetched from Firebase and not when the user accepts an invitation
    this.addGameStream.listen((addedGame) async {
      // TODO: remove addedGame.player02.isEmpty
      // executes when the game is offline
      if (addedGame.isOnline == false || addedGame.player02.isEmpty) {
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
        // adds an InvitationClass object to the opponents user document
        InvitationClass invitation = InvitationClass(
            fromID: addedGame.player01,
            toID: addedGame.player02,
            gameID: addedGame.id,
            fromUsername: await cloudFirestoreDatabase.getUsernameForUserID(
                userID: addedGame.player01),
            toUsername: await cloudFirestoreDatabase.getUsernameForUserID(
                userID: addedGame.player02));
        this.cloudFirestoreDatabase.addInvitationToFirestore(
            userID: addedGame.player02, invitation: invitation);
        // // adds the gameID to the second player
        // this.cloudFirestoreDatabase.addGameIDToFirestore(
        //     userID: addedGame.player02, gameID: addedGame.id);
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
      if (updatedGame.player02.isEmpty || updatedGame.isOnline == false) {
        int indexInIf = this.localGamesList.indexWhere(
            (GameClass outdatedGame) => outdatedGame.id == updatedGame.id);
        print("games " + gamesList.toString());
        print("index " + indexInIf.toString());
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
      if (deletedGame.player02.isEmpty || deletedGame.isOnline == false) {
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
          gameTitlesList
              .removeWhere((currentTitle) => deletedGame.title == currentTitle);
          // deletes the gameID locally
          gameIDsList.removeWhere((currentID) => currentID == deletedGame.id);
          // deletes the game locally
          gamesList
              .removeWhere((currentGame) => currentGame.id == deletedGame.id);
          gamesListSink.add(this.gamesList);
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
          gameTitlesList
              .removeWhere((currentTitle) => deletedGame.title == currentTitle);
          // deletes the gameID locally
          gameIDsList.removeWhere((currentID) => currentID == deletedGame.id);
          // deletes the game locally
          gamesList
              .removeWhere((currentGame) => currentGame.id == deletedGame.id);
          gamesListSink.add(this.gamesList);
        }
      }
    });
  }

  // gets all the important values to function this class
  Future<void> getGamesAndImportantValues() async {
    // fetches the games from the local file system
    String jsonString = await LocalDatabaseFileRoutines().readFileAsString();
    this.localGamesList = gamesListFromJsonString(jsonString);
    // adds something to the gamesListSink Stream (otherwise the snapshot wouldn't get anything because the for loop wouldn't execute)
    if (this.localGamesList.isEmpty || localGamesList.length == 0) {
      this.gamesListSink.add(this.gamesList);
    }
    // adds each local game to gamesListSink
    for (GameClass currentGame in this.localGamesList) {
      this.gamesList.add(currentGame);
      this.gameTitlesList.add(currentGame.title);
      gamesListSink.add(this.gamesList);
    }

    // only executes when the user is signed in
    if (await authenticationService.currentUser() != null) {
      // userID of the current user
      this.currentUserID = await authenticationService.currentUserUid();
      // fetches the gameIDs from CloudFirestore
      List<dynamic> gameIDsInFunction = await cloudFirestoreDatabase
              .getGameIDsFromFirestore(userID: this.currentUserID ?? "") ??
          [];
      // if the user hasn't any gameIDs (or any local games) the for loop wouldn't execute and gamesListSink wouldn't get anything
      if (gameIDsInFunction.length == 0 || gameIDsInFunction.isEmpty) {
        this.gamesListSink.add(this.gamesList);
      }
      // adds all the fetched gameIDs to gameIDsList
      // adds each gameID to the gameIDSink, which passes it down the Stream Tree
      // could be removed
      // for (String currentGameID in gameIDsInFunction) {
      //   gameIDsList.add(currentGameID);
      // }
      // // has to be like this, otherwise an error would occur when the user has no games and accepts an invitation
      for (String currentGameID in gameIDsInFunction) {
        gameIDSink.add(currentGameID);
      }
      // fetches the invitations from CloudFirestore
      List<dynamic> invitationsInFunction = await cloudFirestoreDatabase
          .getInvitations(userID: this.currentUserID);
      // adds each Invitation to invitationList
      for (Map<String, dynamic> currentInvitationMap in invitationsInFunction) {
        InvitationClass currentInvitation =
            InvitationClass.fromJsonMap(currentInvitationMap);
        this.invitationsList.add(currentInvitation);
      }
      invitationsListSink.add(invitationsList);
    }
  }

  // refreshes, reloads and refetches the list of games from Firebase
  Future<void> refreshAll({bool updateInvitationsListStream = false}) async {
    // resolves the issue of showing the same games multiple times
    if (gameIDsList.isEmpty) {
      invitationsList.clear();
      // only executes when the user is signed in
      if (await authenticationService.currentUser() != null) {
        // userID of the current user
        String currentUserIDInFunction =
            await authenticationService.currentUserUid();
        List<dynamic> invitationsInFunction = await cloudFirestoreDatabase
            .getInvitations(userID: currentUserIDInFunction);
        // adds each Invitation to invitationList
        for (Map<String, dynamic> currentInvitationMap
            in invitationsInFunction) {
          InvitationClass currentInvitation =
              InvitationClass.fromJsonMap(currentInvitationMap);
          this.invitationsList.add(currentInvitation);
        }
        invitationsListSink.add(invitationsList);
      }
      return;
    }
    gameIDsList.clear();
    gamesList.clear();
    localGamesList.clear();
    gameTitlesList.clear();
    invitationsList.clear();
    await getGamesAndImportantValues();
    print("invitationsList: " + invitationsList.toString());
    if (updateInvitationsListStream) {
      invitationsListSink.add(invitationsList);
    }
  }

  // TODO: make this better (maybe reuse some other function)
  // refreshes, reloads and refetches the list of games from Firebase
  Future<void> refreshAllAfterSigningIn(
      {bool updateInvitationsListStream = false}) async {
    gameIDsList.clear();
    gamesList.clear();
    localGamesList.clear();
    gameTitlesList.clear();
    invitationsList.clear();
    await getGamesAndImportantValues();
    if (updateInvitationsListStream) {
      invitationsListSink.add(invitationsList);
    }
  }

  Future<void> refreshOnlineGames() async {
    gameIDsList.clear();
    gamesList.clear();
    gameTitlesList.clear();
    // adds each local game to gamesListSink
    for (GameClass currentGame in this.localGamesList) {
      this.gamesList.add(currentGame);
      this.gameTitlesList.add(currentGame.title);
    }
    // fetches the gameIDs from CloudFirestore
    List<dynamic> gameIDsInFunction = await cloudFirestoreDatabase
            .getGameIDsFromFirestore(userID: this.currentUserID ?? "") ??
        [];
    // adds all the fetched gameIDs to gameIDsList
    // adds each gameID to the gameIDSink, which passes it down the Stream Tree
    for (String currentGameID in gameIDsInFunction) {
      gameIDsList.add(currentGameID);
      gameIDSink.add(currentGameID);
    }
  }

  // refreshes invitationList and invitationListStream
  Future<void> refreshInvitations() async {
    invitationsList.clear();
    // fetches the invitations from CloudFirestore
    List<dynamic> invitationsInFunction =
        await cloudFirestoreDatabase.getInvitations(userID: this.currentUserID);
    // adds each Invitation to invitationList
    for (Map<String, dynamic> currentInvitationMap in invitationsInFunction) {
      InvitationClass currentInvitation =
          InvitationClass.fromJsonMap(currentInvitationMap);
      this.invitationsList.add(currentInvitation);
    }
    this.invitationsListSink.add(this.invitationsList);
    return;
  }

  // refreshes invitationListStream
  void refreshInvitationListStream() {
    this.invitationsListSink.add(this.invitationsList);
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
    invitationsListController.close();
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
