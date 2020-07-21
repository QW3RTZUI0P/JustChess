// authentication.dart
import "package:firebase_auth/firebase_auth.dart";

// abstract class to ensure the AuthenticationService class to be platform independent
abstract class AuthenticationApi {
  getFirebaseAuth();
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
  Future<void> deleteAccount();
  Future<void> sendResetPasswortEmail();
  Future<bool> isEmailVerified();
}

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<String> currentUserUid() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid ?? "";
  }

  Future<String> currentUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<String> createUserWithEmailAndPassword({
    String email,
    String password,
    String username,
  }) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = username;
    result.user.updateProfile(updateInfo);
    return result.user.uid;
  }

  Future<void> deleteAccount() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.delete();
    return null;
  }

  Future<void> sendResetPasswortEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    _firebaseAuth.sendPasswordResetEmail(email: user.email);
    return null;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
