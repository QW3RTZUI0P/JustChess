// partienProvider.dart
import "../imports.dart";
import "dart:convert";

// dieser Provider regelt das gesamte State Management
class PartienProvider with ChangeNotifier {
  PartienProvider() {
    istErsterStart();
  }

  List<PartieKlasse> partien = [];

  // Funktionen, die während der Initialisation ausgeführt werden
  Future<bool> istErsterStart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool istErsterStartInFunction =
        sharedPreferences.getBool("istErsterStart") ?? true;
    if (istErsterStartInFunction == true) {
      sharedPreferences.setBool("istErsterStart", false);
      sharedPreferences.setStringList("partienIDs", []);
    }
    return istErsterStartInFunction;
  }
}



