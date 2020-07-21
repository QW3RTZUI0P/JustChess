// gameClass.dart
import "../imports.dart";

// TODO: change id to uuid from uuid package

// Sammelobjekt aller Daten zu einer bestimmten Partie
// wird in CloudFirestore "game" genannt
class GameClass {
  // die einzigartigeID jeder Partie (ist eine)
  String id;
  // normal: name of the game
  // premium: subtitle of the game
  // for the name of the game, JustChess will use the name of the opponent
  // if someone plays more than one game against the same opponent, this value can be uses to distinguish these games
  String subtitle;
  // aktuelle Stellung des Schachspiels in dem Standard "Portable Game Notation"
  String pgn;

  // wichtige Werte für das Spielen mit Freunden
  // Herausforderer (userID des Herausforderers)
  // wenn die Partie ohne Gegner gespielt wird ist dies einfach der aktuelle User
  String player01;
  // Gegner (userID des Gegners)
  // wenn die Partie ohne Gegner gespielt wird, bleibt dieses Feld leer
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
    this.subtitle = "",
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
      subtitle: otherGame.subtitle,
      pgn: otherGame.pgn,
      player01: otherGame.player01,
      player02: otherGame.player02,
      player01IsWhite: otherGame.player01IsWhite,
      whitesTurn: otherGame.whitesTurn,
      moveCount: otherGame.moveCount,
      canBeDeleted: otherGame.canBeDeleted,
    );
  }

  // transforms a DocumentSnapshot from Cloud Firestore to a PartieKlasse object
  factory GameClass.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data ?? {};
    return GameClass(
      id: data["id"],
      subtitle: data["subtitle"],
      pgn: data["pgn"],
      player01: data["player01"],
      player02: data["player02"],
      player01IsWhite: data["player01IsWhite"],
      whitesTurn: data["whitesTurn"],
      moveCount: data["moveCount"],
      canBeDeleted: data["canBeDeleted"] ?? false,
    );
  }

  // Funktionen um die Partien aus dem lokalen Json-File zu extrahieren oder sie in das Json-File zu schreiben
  factory GameClass.fromJson(Map<String, dynamic> json) {
    print("game class from json");
    GameClass game = GameClass(
      id: json["id"] ?? "",
      subtitle: json["subtitle"],
      pgn: json["pgn"],
      player01: json["player01"],
      player02: json["player02"],
      player01IsWhite: json["player01IsWhite"],
      whitesTurn: json["whitesTurn"],
      moveCount: json["moveCount"],
      canBeDeleted: json["canBeDeleted"],
    );
    print("subtitle " + game.subtitle);
    return game;
  }

  Map<String, dynamic> toJson() => {
        "id": this.id ?? "",
        "subtitle": this.subtitle,
        "pgn": this.pgn,
        "player01": this.player01,
        "player02": this.player02,
        "player01IsWhite": this.player01IsWhite,
        "whitesTurn": this.whitesTurn,
        "moveCount": this.moveCount,
        "canBeDeleted": this.canBeDeleted,
      };

  // erstellt eine einzigartige ID für die Partie
  void erstelleID() {
    this.id = Uuid().v4();
  }
}
