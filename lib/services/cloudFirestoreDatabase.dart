// cloudFirestoreDatabase.dart
import 'package:JustChess/imports.dart';

abstract class CloudFirestoreDatabaseApi {
  void addGameID({String userID, String gameID});
  void deleteGameID({String userID, String gameID});
  // holt die Liste der gameIDs aus dem Dokument des angemeldeten users
  Stream<List<String>> getGameIDs({String userID});
  void addUser({String userID, String username});
  // holt die Partie mit der gegebenen ID
  Future<PartieKlasse> getGame({String gameID});
  // fügt der gameID Liste des Users die neue gameID hinzu und
  // - erstellt eine neue Partie in der games collection
  // oder
  // - fügt die userID einem existierenden game hinzu
  void addGame({PartieKlasse game});
  // updatet ein game in der games collection
  void updateGame({PartieKlasse game});
  // löscht ein game in der games collection
  void deleteGame({String id});
}

// implementiert CloudFirestoreDatabaseApi
// übernimmt die Kommunikation mit der Cloud Firestore Datenbank in Firebase
class CloudFirestoreDatabase implements CloudFirestoreDatabaseApi {
  Firestore _firestore = Firestore.instance;
  String _userCollection = "users";
  String _gamesCollection = "games";

  // functions in the user collection
  // adds a gameID to the gameIDs value in the users collection
  void addGameID({String userID, String gameID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).document(userID).get();
    List<String> gameIDs = []; //= snapshot.data["gameIDs"] ?? [];
    gameIDs.add(gameID);
    await _firestore.collection(_userCollection).document(userID).updateData({
      "gameIDs": gameIDs,
    });
  }

  // deletes a gameID
  void deleteGameID({String userID, String gameID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).document(userID).get();
    List<String> gameIDs = snapshot.data["gameIDs"];
    gameIDs.remove(gameID);
    await _firestore
        .collection(_userCollection)
        .document(userID)
        .updateData({"gameIDs": gameIDs});
  }

  // fetches all the current gameIDs from the Users object in the users collection
  Stream<List<String>> getGameIDs({String userID}) {
    return _firestore
        .collection(_userCollection)
        .document(userID)
        .snapshots()
        .map((documentSnapshot) {
      List<String> gameIDs = documentSnapshot.data["gameIDs"];
      return gameIDs;
    });
  }

  // adds an user to the users collection
  void addUser({
    String userID,
    String username,
  }) async {
    await _firestore
        .collection(_userCollection)
        .document(userID)
        .setData({"username": username, "gameIDs": []});
  }

  // function in the games collection
  Future<PartieKlasse> getGame({String gameID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_gamesCollection).document(gameID).get();
    PartieKlasse game = PartieKlasse.vonDocumentSnapshot(snapshot);
    return game;
  }

  void addGame({PartieKlasse game}) async {
    // adds a game to the games collection
    await _firestore.collection(_gamesCollection).document(game.id).setData({
      "id": game.id,
      "name": game.name,
      "pgn": game.pgn,
      "player01": game.player01,
      "player02": game.player02,
      "player01IsWhite": game.player01IsWhite,
      "moveCount": game.moveCount,
    });
  }

  void updateGame({PartieKlasse game}) async {
    await _firestore.collection(_gamesCollection).document(game.id).updateData({
      "name": game.name,
      "pgn": game.pgn,
      "player02": game.player02,
      "moveCount": game.moveCount,
    });
  }

  void deleteGame({String id}) async {
    await _firestore.collection(_gamesCollection).document(id).delete();
  }
}

// // DAS HIER ALLES IST SCHEIßE!!!!!!!!!!!!!!
//   Stream<List<PartieKlasse>> getGames({List<String> gameIDs}) {
//     StreamController<List<PartieKlasse>> streamController =
//         StreamController<List<PartieKlasse>>();
//     Sink<List<PartieKlasse>> _addGame = streamController.sink;
//     Stream<List<PartieKlasse>> games = streamController.stream;
//     for (String currentID in gameIDs) {
//       _firestore
//           .collection(_gamesCollection)
//           .document(currentID)
//           .snapshots()
//           .map((currentSnapshot) async {
//         List<PartieKlasse> gamesList = await games.single;
//         gamesList.add(PartieKlasse.vonDocumentSnapshot(currentSnapshot));
//         _addGame.add(gamesList);
//       });
//       return games;
//     }
//     streamController.close();
//     // wahrscheinlich unnötig
//     // gameIDs.map((currentID) async {
//     //   DocumentSnapshot snapshot = await _firestore.collection(_gamesCollection).document(currentID).get();
//     //   return PartieKlasse.vonDocumentSnapshot(snapshot);
//     // }).toList(growable: true);
//   }

//   // wahrscheinlich unnötig
//   // leider darf man in Blocs nur Streams benutzen, deswegen geht das hier leider nicht
//   // aber ich behalte es mal da, weil diese Klasse ja eigentlich kein Bloc ist

//   // Future<List<PartieKlasse>> getGames({List<String> gameIDs}) async {
//   //   List<PartieKlasse> games = [];
//   //   for (String currentID in gameIDs) {
//   //     DocumentSnapshot snapshot = await _firestore.collection(_gamesCollection).document(currentID).get();
//   //     games.add(PartieKlasse.vonDocumentSnapshot(snapshot));
//   //   }
//   //   return games;
//   //   // wahrscheinlich unnötig
//   //   // gameIDs.map((currentID) async {
//   //   //   DocumentSnapshot snapshot = await _firestore.collection(_gamesCollection).document(currentID).get();
//   //   //   return PartieKlasse.vonDocumentSnapshot(snapshot);
//   //   // }).toList(growable: true);
//   // }
