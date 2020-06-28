// loginBloc.dart
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

import "../imports.dart";

class LoginBloc {
  final AuthenticationApi authenticationService;
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  LoginBloc({
    this.authenticationService,
    this.cloudFirestoreDatabase,
  });

  Future<String> createAccount({String email, String password, String username}) async {
    // creates a new user account in Firebase Auth
    String userID = await authenticationService
        .createUserWithEmailAndPassword(email: email, password: password);
    //     .then((_) async {
    //   await authenticationService.sendEmailVerification();
    // });
    // creates a new User object in the users collection in Cloud firestore
    cloudFirestoreDatabase.addUser(userID: userID, username: username);

    print("Account created");

    return userID;
  }

  Future<String> signIn({String email, String password}) async {
    String userID = await authenticationService.signInWithEmailAndPassword(
        email: email, password: password);
        print("Signed in");
        return userID;
  }
}
