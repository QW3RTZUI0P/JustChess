// localDatabase.dart
import 'dart:convert';
import "../imports.dart";
import "package:path_provider/path_provider.dart";

// class that handles the reading and writing from and to the user's file system
class LocalDatabaseFileRoutines {
  String fileName = "localGames.json";

  // gets the local path
  Future<String> get _localPath async {
    // needs path_provider package
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // returns the json file with the local data
  Future<File> get _localFile async {
    final String path = await _localPath;
    // needs dart:io
    return File("$path/$fileName");
  }

  // returns the content of the file as a string
  Future<String> readFileAsString() async {
    try {
      final File file = await _localFile;
      if (!file.existsSync()) {
        print("This file doesn't exist.");
        writeFile(jsonString: '{"games": []}');
      }
      String content = await file.readAsString();
      return content;
    } catch (e) {
      print("Error reading file: $e");
      return "";
    }
  }

  // writes the given content into the file with the database
  Future<File> writeFile({String jsonString}) async {
    final File file = await _localFile;
    return file.writeAsString('$jsonString');
  }
}

//
// for better readability
//
List<GameClass> gamesListFromJsonString(String jsonString) {
  final Map<String, dynamic> jsonObject = jsonDecode(jsonString);
  List<GameClass> gamesListInFunction = List.generate(
    jsonObject["games"].length,
    (int index) => GameClass.fromJson(jsonObject["games"][index]),
  );
  return gamesListInFunction ?? [];
}

/// takes the given List<GameClass> and converts it to a json String
String gamesListToJsonString(List<GameClass> gamesList) {
  final Map<String, dynamic> jsonObject = {"games": []};
  gamesList.forEach((GameClass currentGame) {
    jsonObject["games"].add(currentGame.toJson());
  });
  return jsonEncode(jsonObject) ?? "";
}
