// main.dart
import 'package:JustChess/seiten/registrierung.dart';
import 'package:JustChess/services/cloudFirestoreDatabase.dart';

import "imports.dart";

void main() => runApp(JustChess());

// class JustChess extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => PartienProvider(),
//       child: MaterialApp(
//         title: "JustChess",
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(),
//         home: MeinBuilder(),
//       ),
//     );
//   }
// }

class JustChess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(authenticationService: _authenticationService);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: GameBlocProvider(
        gameBloc: GameBloc(
          cloudFirestoreDatabase: CloudFirestoreDatabase(),
          authenticationService: AuthenticationService(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: StreamBuilder(
              initialData: null,
              // je nachdem ob der User ein- oder ausgeloggt ist, wird
              // Login oder Home ausgegeben
              stream: _authenticationBloc.user,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // wird ausgeführt, während das Gerät die Verbindung zu Cloud Firestore aufbaut und auf eine Antwort wartet
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
                // wird ausgeführt, wenn FirebaseAuth eine UserUID zurückgibt, also wenn ein User schon angemeldet war
                else if (snapshot.hasData) {
                  return Home();
                }
                // wird ausgeführt, wenn FirebaseAuth nichts zurückgibt, also wenn noch kein User angemeldet ist
                else {
                  return Registrierung();
                }
              }),
        ),
      ),
    );
  }
}
