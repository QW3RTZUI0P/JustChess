// gameClass.dart
import "../imports.dart";

// TODO: remove all the data["subtitle"] references

// Sammelobjekt aller Daten zu einer bestimmten Partie
// wird in CloudFirestore "game" genannt
class GameClass {
  // die einzigartigeID jeder Partie (ist eine)
  String id;
  // normal: name of the game
  // premium: subtitle of the game
  // for the name of the game, JustChess will use the name of the opponent
  // if someone plays more than one game against the same opponent, this value can be uses to distinguish these games
  String title;
  // aktuelle Stellung des Schachspiels in dem Standard "Portable Game Notation"
  String pgn;

  // wichtige Werte für das Spielen mit Freunden
  // Herausforderer (userID des Herausforderers)
  // wenn die Partie ohne Gegner gespielt wird ist dies einfach der aktuelle User
  String player01;
  // opponent (userID of the opponent)
  // if the game is offline, this value is empty
  String player02;
  bool player01IsWhite;
  // whether white has to make a turn
  bool whitesTurn;
  // shows the overall move number (one move = white did one turn and black did one)
  int moveCount;
  // shows the current status of the game
  // "playing": game is currently being played
  // "stalemate": game is in stalemate
  // "whiteWon": white won the game
  // "blackWon": black won the game
  // "draw": one player proposed a draw
  // "whiteGaveUp": white gave up
  // "blackGaveUp": black gave up
  //
  // is stored in CloudFirestore as String values
  // is converted to Strings in toJson()
  GameStatus gameStatus;
  // whether the game is online or offline
  // for games stored in CloudFirestore this is always true
  // for games stored locally this is always false
  bool isOnline;
  // default is false
  // if the first player deletes this game, this will change to true
  // if the second player deletes this game, this game will actually be deleted
  bool canBeDeleted;

  GameClass({
    this.id,
    this.title = "",
    this.pgn = "",
    this.player01 = "",
    this.player02 = "",
    this.player01IsWhite = true,
    this.whitesTurn = true,
    this.moveCount = 0,
    this.gameStatus = GameStatus.playing,
    this.isOnline,
    this.canBeDeleted = false,
  });

  // creates a copy of the given object
  factory GameClass.from(GameClass otherGame) {
    return GameClass(
      id: otherGame.id,
      title: otherGame.title,
      pgn: otherGame.pgn,
      player01: otherGame.player01,
      player02: otherGame.player02,
      player01IsWhite: otherGame.player01IsWhite,
      whitesTurn: otherGame.whitesTurn,
      moveCount: otherGame.moveCount,
      gameStatus: otherGame.gameStatus,
      isOnline: otherGame.isOnline,
      canBeDeleted: otherGame.canBeDeleted,
    );
  }

  // transforms a DocumentSnapshot from CloudFirestore to a GameClass object
  factory GameClass.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() ?? {};
    return GameClass(
      id: data["id"],
      title: data["subtitle"] ?? data["title"],
      pgn: data["pgn"],
      player01: data["player01"],
      player02: data["player02"],
      player01IsWhite: data["player01IsWhite"],
      whitesTurn: data["whitesTurn"],
      moveCount: data["moveCount"],
      gameStatus: transformStringToGameStatus(string: data["gameStatus"]) ??
          GameStatus.playing,
      isOnline: data["isOnline"] ?? true,
      canBeDeleted: data["canBeDeleted"] ?? false,
    );
  }

  /// takes the given jsonObject and converts it to a GameClass object
  factory GameClass.fromJson(Map<String, dynamic> jsonObject) {
    GameClass game = GameClass(
      id: jsonObject["id"] ?? "",
      title: jsonObject["subtitle"] ?? jsonObject["title"] ?? "",
      pgn: jsonObject["pgn"] ?? "",
      player01: jsonObject["player01"] ?? "",
      player02: jsonObject["player02"] ?? "",
      player01IsWhite: jsonObject["player01IsWhite"] ?? "",
      whitesTurn: jsonObject["whitesTurn"],
      moveCount: jsonObject["moveCount"],
      gameStatus:
          transformStringToGameStatus(string: jsonObject["gameStatus"]) ??
              GameStatus.playing,
      isOnline: jsonObject["isOnline"] ?? false,
      canBeDeleted: jsonObject["canBeDeleted"],
    );
    return game;
  }

  /// returns a map with the values of this GameClass object
  /// suits for local json storing and for CloudFirestore
  Map<String, dynamic> toJson() => {
        "id": this.id ?? "",
        "title": this.title,
        "pgn": this.pgn,
        "player01": this.player01,
        "player02": this.player02,
        "player01IsWhite": this.player01IsWhite,
        "whitesTurn": this.whitesTurn,
        "moveCount": this.moveCount,
        "gameStatus": this.gameStatus.toString(),
        "isOnline": this.isOnline,
        "canBeDeleted": this.canBeDeleted,
      };

  /// creates a unique ID for this GameClass
  void createUniqueID() {
    this.id = Uuid().v4();
  }
}

enum GameStatus {
  playing,
  stalemate,
  whiteWon,
  blackWon,
  draw,
  whiteProposedDraw,
  blackProposedDraw,
  whiteGaveUp,
  blackGaveUp,
}

/// transforms the given String to a GameStatus value
GameStatus transformStringToGameStatus({String string}) {
  switch (string) {
    case "GameStatus.playing":
      return GameStatus.playing;
    case "GameStatus.stalemate":
      return GameStatus.stalemate;
    case "GameStatus.whiteWon":
      return GameStatus.whiteWon;
    case "GameStatus.blackWon":
      return GameStatus.blackWon;
    case "GameStatus.draw":
      return GameStatus.draw;
    case "GameStatus.whiteProposedDraw":
      return GameStatus.whiteProposedDraw;
    case "GameStatus.blackProposedDraw":
      return GameStatus.blackProposedDraw;
    case "GameStatus.whiteGaveUp":
      return GameStatus.whiteGaveUp;
    case "GameStatus.blackGaveUp":
      return GameStatus.blackGaveUp;
    default:
      return GameStatus.playing;
  }
}
