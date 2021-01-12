// authentication.dart
import "package:firebase_auth/firebase_auth.dart";

// abstract class to ensure the AuthenticationService class to be platform independent
abstract class AuthenticationApi {
  getFirebaseAuth();
  Future<dynamic> currentUser();
  Future<String> currentUserUid();
  Future<String> currentUserEmail();
  Future<void> signOut();
  Future<String> signInWithEmailAndPassword({String email, String password});
  // erstellt einen User, der mit seiner Email Adresse und seinem Passwort authentifiziert wird
  // erstellt außerdem in CloudFirestore in der users collection einen Eintrag
  Future<String> createUserWithEmailAndPassword({
    String email,
    String password,
    String username,
  });
  Future<void> sendEmailVerification();
  Future<UserCredential> deleteAccount({String email, String password});
  Future<void> sendResetPasswortEmail({String email});
  Future<bool> isEmailVerified();
}

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<dynamic> currentUser() async {
    print("hello");
    dynamic user = _firebaseAuth.currentUser;
    print("world");
    return user;
  }

  Future<String> currentUserUid() async {
    User user = _firebaseAuth.currentUser;
    return user != null ? user.uid : "";
  }

  Future<String> currentUserEmail() async {
    User user = _firebaseAuth.currentUser;
    return user.email;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user.uid;
  }

  Future<String> createUserWithEmailAndPassword({
    String email,
    String password,
    String username,
  }) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    print(credential.toString());
    credential.user.updateProfile(displayName: username);
    return credential.user.uid;
  }

  // Future<String> reauthenticateWithEmailAndPassword({String email, String password}) async {
  //   User user = await _firebaseAuth.currentUser();

  //   user.reauthenticateWithCredential()
  // }

  // reauthenticates and deletes the current user's account in Firebase Authentication
  Future<UserCredential> deleteAccount({String email, String password}) async {
    User user = _firebaseAuth.currentUser;

    try {
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      // reauthenticates the user
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);
      // deletes the user
      await result.user.delete();
      return result;
    } catch (error) {
      print("Error type: " + error.runtimeType.toString());
      print("Error: " + error.toString());
      throw (error);
    }
  }

  Future<void> sendResetPasswortEmail({String email}) async {
    String emailInFunction = email;
    // if the user is signed in, the stored user email is used
    if (email == null) {
      User user = _firebaseAuth.currentUser;
      emailInFunction = user.email;
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailInFunction);
    } catch (error) {
      throw error;
    }
    return null;
  }

  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    await user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}
