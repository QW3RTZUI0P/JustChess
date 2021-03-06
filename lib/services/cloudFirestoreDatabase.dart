// cloudFirestoreDatabase.dart
import 'package:JustChess/imports.dart';
// for PlatformException
import "package:flutter/services.dart";

// abstract class to make CloudFirestoreDatabase platform independent
abstract class CloudFirestoreDatabaseApi {
  // fetches the gameIDs of the current user
  Future<List<dynamic>> getGameIDsFromFirestore({@required String userID});
  Future<List<String>> getUsernamesList();
  Future<String> getUsernameForUserID({@required String userID});
  Future<dynamic> getUserIDForUsername({@required String username});
  Future<List<dynamic>> getInvitations({@required String userID});
  Future<List<dynamic>> getFriendsList({@required String userID});
  //
  // adds a gameID to the gameIDs value of the current user's object in the user collection
  void addGameIDToFirestore({@required String userID, @required String gameID});
  // deletes a gameID to the gameIDs value of the current user's object in the user collection
  void deleteGameIDFromFirestore(
      {@required String userID, @required String gameID});
  void addInvitationToFirestore(
      {@required String userID, @required InvitationClass invitation});
  void deleteInvitationFromFirestore(
      {@required String userID, @required InvitationClass invitation});
  // adds a user object with all the important values to the users collection
  void addUserToFirestore({
    @required String userID,
    @required String username,
  });
  void deleteUserFromFirestore(
      {@required String userID, @required String username});
  //
  //
  // fetches the game with the given gameID
  Future<GameClass> getGameFromFirestore({@required String gameID});
  // adds a game in the games collection
  void addGameToFirestore({@required GameClass game});
  // updatet ein game in der games collection
  void updateGameFromFirestore({@required GameClass game});
  // löscht ein game in der games collection
  void deleteGameFromFirestore({@required String gameID});
  void addFriendToFirestore(
      {@required String userID, @required String nameOfTheFriend});
  void deleteFriendFromFirestore(
      {@required String userID, @required String nameOfTheFriend});
  // void inviteOpponentToGame(
  //     {@required String gameID, @required String opponentUserID});
}

// TODO: minimize CloudFirestore database accesses

// implements CloudFirestoreDatabaseApi
// manages the communication with the CloudFirestore database in Firebase
class CloudFirestoreDatabase implements CloudFirestoreDatabaseApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userCollection = "users";
  String _gamesCollection = "games";

  //
  //
  // functions in the users collection:
  // functions for getting values:
  // fetches all the current gameIDs from the Users object in the users collection
  Future<List<dynamic>> getGameIDsFromFirestore(
      {@required String userID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    return snapshot.data()["gameIDs"] ?? [];
  }

  // gets a list with all the usernames in use
  Future<List<String>> getUsernamesList() async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc("usernames").get();
    List<String> usernamesList = List.generate(
      snapshot["usernames"].length,
      (index) => snapshot["usernames"][index].toString(),
    );
    return usernamesList;
  }

  // gets the username for the given userID
  Future<String> getUsernameForUserID({@required String userID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    return snapshot.data()["username"];
  }

  // gets the uid for the given username
  Future<String> getUserIDForUsername({@required String username}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc("usernames").get();
    String userID = snapshot.data()["userIDs"][username];
    return userID;
  }

  // gets the user's invitations
  Future<List<dynamic>> getInvitations({@required String userID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    return snapshot.data()["invitations"] ?? [];
  }

  // gets the List of friends of the user with the given userID
  Future<List<dynamic>> getFriendsList({@required String userID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    List<dynamic> friendsList = snapshot.data()["friends"] ?? [];
    return friendsList;
  }

  //
  // functions for manipulating values:
  // adds a gameID to the gameIDs value in the users collection
  void addGameIDToFirestore(
      {@required String userID, @required String gameID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    List<dynamic> gameIDs = snapshot.data()["gameIDs"] ?? [];
    gameIDs.add(gameID);
    await _firestore.collection(_userCollection).doc(userID).update({
      "gameIDs": gameIDs,
    });
  }

  // deletes a gameID
  void deleteGameIDFromFirestore(
      {@required String userID, @required String gameID}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    List<dynamic> gameIDs = snapshot.data()["gameIDs"];
    // String username = snapshot.data()["username"];
    gameIDs.remove(gameID);
    await _firestore.collection(_userCollection).doc(userID).update({
      "gameIDs": gameIDs,
      // "username": username,
    });
  }

  // adds an invitation to the user's document
  void addInvitationToFirestore(
      {@required String userID, @required InvitationClass invitation}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    List<dynamic> invitations = snapshot.data()["invitations"] ?? [];
    print(
      "add invitation " + invitation.toJsonMap().toString(),
    );
    invitations.add(invitation.toJsonMap());
    await _firestore
        .collection(_userCollection)
        .doc(userID)
        .update({"invitations": invitations});
  }

  // deletes an invitation from the user's document
  Future<void> deleteInvitationFromFirestore(
      {@required String userID, @required InvitationClass invitation}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();
    List<dynamic> invitations = snapshot.data()["invitations"] ?? [];
    invitations.removeWhere(
        (invitationToTest) => invitationToTest["gameID"] == invitation.gameID);

    await _firestore
        .collection(_userCollection)
        .doc(userID)
        .update({"invitations": invitations});

    return;
  }

  /// adds an user to the users collection
  /// also used to mark a user as premium if he is subscribed to justchess_premium
  void addUserToFirestore({
    @required String userID,
    @required String username,
  }) async {
    await _firestore.collection(_userCollection).doc(userID).set({
      "gameIDs": [],
      "invitations": [],
      "friends": [],
      "username": username,
    });
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc("usernames").get();
    List<dynamic> usernames = snapshot["usernames"];
    Map<String, dynamic> userIDs = snapshot["userIDs"];
    usernames.add(username);
    userIDs.addEntries([MapEntry(username, userID)]);
    await _firestore
        .collection(_userCollection)
        .doc("usernames")
        .update({"usernames": usernames, "userIDs": userIDs});
  }

  void deleteUserFromFirestore(
      {@required String userID, @required String username}) async {
    // deletes the user's document in the users collection
    await _firestore.collection(_userCollection).doc(userID).delete();
    // gets the document with the usernames list and with the Map<username, userID>
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc("usernames").get();
    List<dynamic> usernames = snapshot.data()["usernames"];
    Map<String, dynamic> userIDs = snapshot.data()["userIDs"];
    // removes username from the usernames list
    usernames.remove(username);
    // removes the MapEntry with the username as the key and the userID as the value from the map
    userIDs.remove(username);
    await _firestore
        .collection(_userCollection)
        .doc("usernames")
        .update({"usernames": usernames, "userIDs": userIDs});
  }

  // adds a friend to firestore
  void addFriendToFirestore(
      {@required String userID, @required String nameOfTheFriend}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();

    Map<String, dynamic> newMap = snapshot.data();
    newMap["friends"].add(nameOfTheFriend);
    await _firestore.collection(_userCollection).doc(userID).update(newMap);
  }

  void deleteFriendFromFirestore(
      {@required String userID, @required String nameOfTheFriend}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(_userCollection).doc(userID).get();

    Map<String, dynamic> newMap = snapshot.data();
    newMap["friends"].remove(nameOfTheFriend);
    await _firestore.collection(_userCollection).doc(userID).update(newMap);
  }

  //
  //
  // functions in the games collection:
  // functions for getting values:
  Future<GameClass> getGameFromFirestore({@required String gameID}) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection(_gamesCollection).doc(gameID).get();
      GameClass game = GameClass.fromDocumentSnapshot(snapshot);
      return game;
    } on PlatformException catch (platformException) {
      print(platformException.toString());
      throw platformException;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  //
  // functions for manipulating values:
  void addGameToFirestore({@required GameClass game}) async {
    // adds a game to the games collection
    await _firestore.collection(_gamesCollection).doc(game.id).set(
          game.toJson(),
        );
  }

  void updateGameFromFirestore({@required GameClass game}) async {
    await _firestore.collection(_gamesCollection).doc(game.id).update(
          game.toJson(),
        );
  }

  void deleteGameFromFirestore({@required String gameID}) async {
    await _firestore.collection(_gamesCollection).doc(gameID).delete();
  }

  // void inviteOpponentToGame({
  //   @required String gameID,
  //   @required String opponentUserID,
  //   @required String opponentUsername,
  //   @required String invitatorUserID,
  //   @required String invitatorUsename,
  // }) async {
  //   Invitation invitation = Invitation(
  //     fromID: invitatorUserID,
  //     toID: opponentUserID,
  //     fromUsername: invitatorUsename,
  //     toUsername: opponentUsername,
  //     gameID: gameID,
  //   );
  //   DocumentSnapshot snapshot = await _firestore
  //       .collection(_userCollection)
  //       .document(opponentUserID)
  //       .get();
  //   Map<String, dynamic> data = snapshot.data();
  //   data["invitations"].add(
  //     invitation.toJson(),
  //   );
  // }
}
