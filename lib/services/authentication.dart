// authentication.dart 
import "package:firebase_auth/firebase_auth.dart";
// abstrakte Klasse, die dafür da ist, dass der AuthenticationBloc plattformunabhängig sein kann
abstract class AuthenticationApi {
  getFirebaseAuth();
  Future<String> currentUserUid();
  Future<void> signOut();
  Future<String> signInWithEmailAndPassword({String email, String password});
  // erstellt einen User, der mit seiner Email Adresse und seinem Passwort authentifiziert wird
  // erstellt außerdem in CloudFirestore in der users collection einen Eintrag
  Future<String> createUserWithEmailAndPassword({String email, String password});
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  
  
  FirebaseAuth getFirebaseAuth() {
    
    return _firebaseAuth;
  }
  Future<String> currentUserUid() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
  Future<String> signInWithEmailAndPassword({String email, String password}) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }
  Future<String> createUserWithEmailAndPassword(
      {String email, String password}) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
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