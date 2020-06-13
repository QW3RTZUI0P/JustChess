// partie.dart

class PartieKlasse {
  final String id;
  final String name;
  String pgn;
  bool benutzerIstWeiss;
  int anzahlDerZuege;

  PartieKlasse({
    this.id = "",
    this.name = "",
    this.pgn = "",
    this.benutzerIstWeiss = true,
    this.anzahlDerZuege = 0,
  });

  factory PartieKlasse.vonJson(Map<String, dynamic> json) => PartieKlasse(
        id: json["id"],
        name: json["name"],
        pgn: json["pgn"],
        benutzerIstWeiss: json["benutzerIstWeiss"],
        anzahlDerZuege: json["anzahlDerZuege"],
      );

  Map<String, dynamic> zuJson() => {
        "id": this.id,
        "name": this.name,
        "pgn": this.pgn,
        "benutzerIstWeiss": this.benutzerIstWeiss,
        "anzahlDerZuege": this.anzahlDerZuege,
      };
}
