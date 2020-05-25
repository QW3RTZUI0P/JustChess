// partienProvider.dart
import "../imports.dart";
import "dart:convert";

class PartienProvider with ChangeNotifier {
  Datenbank datenbank = Datenbank();

  PartienProvider() {
    holePartien();
    print(datenbank.partien);
  }

  void holePartien() async {
    String jsonString = await DatenbankFileRoutinen().leseDokument();
    print("jsonString");
    this.datenbank = datenbankVonJson(jsonString);
    notifyListeners();
  }

  Future<void> neuePartieErstellt({PartieKlasse partie}) {
    this.datenbank.partien.add(partie);
    DatenbankFileRoutinen().schreibeDokument(
      datenbankZuJson(this.datenbank),
    );
    notifyListeners();
  }

  Future<void> partieGeloescht({PartieKlasse partie}) {
    this.datenbank.partien.remove(partie);
    DatenbankFileRoutinen().schreibeDokument(
      datenbankZuJson(this.datenbank),
    );
    notifyListeners();
  }

  Future<void> partieUpgedatet(
      {PartieKlasse altePartie, PartieKlasse neuePartie}) {
    int index = this.datenbank.partien.indexOf(altePartie);
    this.datenbank.partien[index].pgn = neuePartie.pgn;
    DatenbankFileRoutinen().schreibeDokument(
      datenbankZuJson(this.datenbank),
    );
    notifyListeners();
  }
}

class DatenbankFileRoutinen {
  Future<String> get _lokalerPfad async {
    final verzeichnis = await getApplicationDocumentsDirectory();
    return verzeichnis.path;
  }

  Future<File> get _lokalesDokument async {
    final pfad = await _lokalerPfad;
    print(pfad);
    return File('$pfad/gespeichertePartien.json');
  }

  Future<String> leseDokument() async {
    try {
      final dokument = await _lokalesDokument;

      if (!dokument.existsSync()) {
        print("Das Dokument existiert nicht: ${dokument.path}");
        await schreibeDokument('{"partien": []}');
      }
      // hier wird das Dokument gelesen
      String inhalt = await dokument.readAsString();
      return inhalt;
    } catch (e) {
      print("error leseDokument: $e");
      return "";
    }
  }

  Future<File> schreibeDokument(String json) async {
    final dokument = await _lokalesDokument;
    // hier wird das Dokument geschrieben
    return dokument.writeAsString('$json');
  }
}

// um Json Daten zu lesen
Datenbank datenbankVonJson(String str) {
  final datenVonJson = json.decode(str);
  print(datenVonJson.toString());
  return Datenbank.vonJson(datenVonJson);
}

// um Json Daten zu schreiben
String datenbankZuJson(Datenbank datenbank) {
  final datenZuJson = datenbank.zuJson();
  return json.encode(datenZuJson);
}

class Datenbank {
  List<PartieKlasse> partien = [];

  Datenbank({
    this.partien,
  });
  factory Datenbank.vonJson(Map<String, dynamic> json) {
    return Datenbank(
      partien: List<PartieKlasse>.from(
            json["partien"].map(
              (x) => PartieKlasse.vonJson(x),
            ),
          ) ??
          [],
    );
  }

  Map<String, dynamic> zuJson() =>
      {"partien": List<dynamic>.from(partien.map((partie) => partie.zuJson()))};
}
