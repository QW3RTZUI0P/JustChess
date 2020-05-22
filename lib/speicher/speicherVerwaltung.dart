// // speicherVerwaltung.dart
// import "../imports.dart";
// import "dart:convert";


// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();
//   // For your reference print the AppDoc directory
//   print(directory.path);
//   return directory.path;
// }

// Future<File> get _localFile async {
//   final path = await _localPath;
//   return File('$path/gespeichertePartien.txt');
// }

// Future<File> writeContent({String content}) async {
//   final file = await _localFile;
//   return file.writeAsString(content);
// }

// Future<dynamic> readContent() async {
//   try {
//     final file = await _localFile;
//     // Read the file
//     String contents = await file.readAsString();
//     var jsonObjekt = jsonDecode(contents);
//     print(jsonObjekt);
//     return jsonObjekt;
//   } catch (e) {
//     // If there is an error reading, return a default String
//     return {};
//   }
// }

// Future<void> neuePartie() async {
//   var contents = await readContent();

// }

// void loeschePartie({int id}) {}

// Future<bool> istErsterStart() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     bool istErsterStartInFunction =
//         sharedPreferences.getBool("istErsterStart") ?? true;
//     if (istErsterStartInFunction == true) {
//       sharedPreferences.setBool("istErsterStart", false);
//       writeContent(content: "");
//     }
//     return istErsterStartInFunction;
//   }

//   Future<List<PartieKlasse>> holePartien() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     List<int> partienIDs = sharedPreferences.get("partienIDs") ?? [];
//     List<PartieKlasse> partien;
//     String fileContents = await readContent();
//     Map partienAsJson = jsonDecode(fileContents);
//     for (int i = 0; i < partienAsJson.length; i++) {
//       for (int j = 0; j < partienIDs.length; j++) {
//         int aktuellePartieID = partienIDs[j];
//         partien.add(
//               PartieKlasse(
//                   id: partienAsJson[aktuellePartieID].id,
//                   name: partienAsJson[aktuellePartieID].name,
//                   pgn: partienAsJson[aktuellePartieID].pgn),
//             );
//       }
//       return partien;
//     }
//   }