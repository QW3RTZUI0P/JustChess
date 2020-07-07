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

  Future<String> createAccount({@required String email, @required String password, @required String username}) async {
    // creates a new user account in Firebase Auth
    String userID = await authenticationService
        .createUserWithEmailAndPassword(email: email, password: password, username: username,);
    //     .then((_) async {
    //   await authenticationService.sendEmailVerification();
    // });

    // creates a new User object in the users collection in Cloud firestore
    cloudFirestoreDatabase.addUserToFirestore(userID: userID, username: username);

    print("Account created");

    return userID;
  }

  Future<String> signIn({@required String email, @required String password}) async {
    String userID = await authenticationService.signInWithEmailAndPassword(
        email: email, password: password);
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

