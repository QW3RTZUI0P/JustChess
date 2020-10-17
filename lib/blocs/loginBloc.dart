// loginBloc.dart
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

import "../imports.dart";

// TODO: Email Verifizierung einbauen
// TODO: Benachrichtigung, wenn Email oder Benutzername schon in Benutzung sind

class LoginBloc {
  final AuthenticationApi authenticationService;
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  LoginBloc({
    this.authenticationService,
    this.cloudFirestoreDatabase,
  });

  Future<String> createAccount(
      {@required String password, @required String username}) async {
    // I don't use email verification because lots of users then have concerns to sign up
    // it takes instead just the username and adds to it the domain @justchess.com
    // unfortunately it will be impossible to reset the user's passwort then
    String fakeEmail = username + "@justchess.com";
    try {
      // creates a new user account in Firebase Auth
      String userID =
          await authenticationService.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: password,
        username: username,
      );

      //     .then((_) async {
      //   await authenticationService.sendEmailVerification();
      // });

      // creates a new User object in the users collection in Cloud firestore
      cloudFirestoreDatabase.addUserToFirestore(
        userID: userID,
        username: username,
      );

      print("Account created");

      return userID;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<String> signIn(
      {@required String username, @required String password}) async {
    String fakeEmail = username + "@justchess.com";
    if (username.contains("@") && username.contains(".")) {
      fakeEmail = username;
    }
    String userID = await authenticationService.signInWithEmailAndPassword(
        email: fakeEmail, password: password);
    print("Signed in");

    return userID;
  }

  Future<bool> isUsernameAvailable({@required String username}) async {
    List<dynamic> usernames = await cloudFirestoreDatabase.getUsernamesList();
    if (usernames.contains(username)) {
      return false;
    } else {
      return true;
    }
  }
}
