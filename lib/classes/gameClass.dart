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
  bool whitesTurn;
  int moveCount;
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
      canBeDeleted: otherGame.canBeDeleted,
    );
  }

  // transforms a DocumentSnapshot from Cloud Firestore to a GameClass object
  factory GameClass.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data ?? {};
    return GameClass(
      id: data["id"],
      title: data["subtitle"] ?? data["title"],
      pgn: data["pgn"],
      player01: data["player01"],
      player02: data["player02"],
      player01IsWhite: data["player01IsWhite"],
      whitesTurn: data["whitesTurn"],
      moveCount: data["moveCount"],
      canBeDeleted: data["canBeDeleted"] ?? false,
    );
  }

  /// takes the given jsonObject and converts it to a GameClass object
  factory GameClass.fromJson(Map<String, dynamic> jsonObject) {
    print("game class from json");
    GameClass game = GameClass(
      id: jsonObject["id"] ?? "",
      title: jsonObject["subtitle"] ?? jsonObject["title"] ?? "",
      pgn: jsonObject["pgn"] ?? "",
      player01: jsonObject["player01"] ?? "",
      player02: jsonObject["player02"] ?? "",
      player01IsWhite: jsonObject["player01IsWhite"] ?? "",
      whitesTurn: jsonObject["whitesTurn"],
      moveCount: jsonObject["moveCount"],
      canBeDeleted: jsonObject["canBeDeleted"],
    );
    print("subtitle " + game.title);
    return game;
  }

  /// returns a map with the values of this GameClass object
  Map<String, dynamic> toJson() => {
        "id": this.id ?? "",
        "title": this.title,
        "pgn": this.pgn,
        "player01": this.player01,
        "player02": this.player02,
        "player01IsWhite": this.player01IsWhite,
        "whitesTurn": this.whitesTurn,
        "moveCount": this.moveCount,
        "canBeDeleted": this.canBeDeleted,
      };

  /// creates a unique ID for this GameClass
  void createUniqueID() {
    this.id = Uuid().v4();
  }
}
