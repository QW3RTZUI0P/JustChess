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

  PartieKlasse({
    this.id,
    this.name = "",
    this.pgn = "",
    this.player01 = "",
    this.player02 = "",
    this.player01IsWhite = true,
    this.moveCount = 0,
  });

  // wandelt einen Snapshot aus Cloud Firestore zu einer PartieKlasse um
  factory PartieKlasse.vonDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data ?? {};
    return PartieKlasse(
      id: data["id"],
      name: data["name"],
      pgn: data["pgn"],
      player01: data["player01"],
      player02: data["player02"],
      player01IsWhite: data["player01IsWhite"],
      moveCount: data["moveCount"],

    );
  }

  // Funktionen um die Partien aus dem lokalen Json-File zu extrahieren oder sie in das Json-File zu schreiben
  factory PartieKlasse.vonJson(Map<String, dynamic> json) => PartieKlasse(
        id: json["id"],
        name: json["name"],
        pgn: json["pgn"],
        player01IsWhite: json["benutzerIstWeiss"],
        moveCount: json["anzahlDerZuege"],
      );

  Map<String, dynamic> zuJson() => {
        "id": this.id,
        "name": this.name,
        "pgn": this.pgn,
        "benutzerIstWeiss": this.player01IsWhite,
        "anzahlDerZuege": this.moveCount,
      };

  // erstellt eine einzigartige ID für die Partie
    void erstelleID() {
    this.id = this.player01 + DateTime.now().millisecondsSinceEpoch.toString();
  }
}
