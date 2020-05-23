// partie.dart

class PartieKlasse {
  final String id;
  final String name;
  String pgn;

  PartieKlasse({
    this.name = "",
    this.pgn = "",
    this.id = "",
  });

  factory PartieKlasse.vonJson(Map<String, dynamic> json) => PartieKlasse(
        id: json["id"],
        name: json["name"],
        pgn: json["pgn"],
      );

  Map<String, dynamic> zuJson() => {
        "id": this.id,
        "name": this.name,
        "pgn": this.pgn,
      };
}
