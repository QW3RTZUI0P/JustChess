// partie.dart
import "../imports.dart";

// Sammelobjekt aller Daten zu einer bestimmten Partie
// wird in CloudFirestore "game" genannt
class PartieKlasse {
  // die einzigartigeID jeder Partie (ist eine)
  String id;
  // der Name der Partie
  // wenn kein Name vorhanden ist wird in der UI einfach "Partie gegen NAME DES GEGNERS" angezeigt
  final String name;
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
  int moveCount;
  // default is false
  // if the first player deletes this game, this will change to true
  // if the second player deletes this game, this game will actually be deleted
  bool canBeDeleted;

  PartieKlasse({
    this.id,
    this.name = "",
    this.pgn = "",
    this.player01 = "",
    this.player02 = "",
    this.player01IsWhite = true,
    this.moveCount = 0,
    this.canBeDeleted = false,
  });

  // creates a copy of the given object
  factory PartieKlasse.from(PartieKlasse otherGame) {
    return PartieKlasse(
      id: otherGame.id,
      name: otherGame.name,
      pgn: otherGame.pgn,
      player01: otherGame.player01,
      player02: otherGame.player02,
      player01IsWhite: otherGame.player01IsWhite,
      moveCount: otherGame.moveCount,
      canBeDeleted: otherGame.canBeDeleted,
    );
  }

  // transforms a DocumentSnapshot from Cloud Firestore to a PartieKlasse object
  factory PartieKlasse.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data ?? {};
    return PartieKlasse(
      id: data["id"],
      name: data["name"],
      pgn: data["pgn"],
      player01: data["player01"],
      player02: data["player02"],
      player01IsWhite: data["player01IsWhite"],
      moveCount: data["moveCount"],
      canBeDeleted: data["canBeDeleted"] ?? false,
    );
  }

  // Funktionen um die Partien aus dem lokalen Json-File zu extrahieren oder sie in das Json-File zu schreiben
  factory PartieKlasse.fromJson(Map<String, dynamic> json) => PartieKlasse(
        id: json["id"],
        name: json["name"],
        pgn: json["pgn"],
        player01: json["player01"],
        player02: json["player02"],
        player01IsWhite: json["player01IsWhite"],
        moveCount: json["moveCount"],
        canBeDeleted: json["canBeDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "name": this.name,
        "pgn": this.pgn,
        "player01": this.player01,
        "player02": this.player02,
        "player01IsWhite": this.player01IsWhite,
        "moveCount": this.moveCount,
        "canBeDeleted": this.canBeDeleted,
      };

  // erstellt eine einzigartige ID für die Partie
  void erstelleID() {
    this.id = this.player01 + DateTime.now().millisecondsSinceEpoch.toString();
  }
}
