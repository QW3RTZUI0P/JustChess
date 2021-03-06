// // main.dart
// import "imports.dart";

// // in app purchase tutorial from: https://fireship.io/lessons/flutter-inapp-purchases/

// void main() => runApp(JustChess());

// class JustChess extends StatefulWidget {
//   @override
//   _JustChessState createState() => _JustChessState();
// }

// class _JustChessState extends State<JustChess> {
//   @override
//   Widget build(BuildContext context) {
//     // class with all the methods needed for authentication
//     final AuthenticationService _authenticationService =
//         AuthenticationService();
//     // class with all the methods needed for reading and writing from and to CloudFirestore
//     final CloudFirestoreDatabaseApi _cloudFirestoreDatabase =
//         CloudFirestoreDatabase();

//     // has to be local variable because its values are being used in the StreamBuilder below
//     final AuthenticationBloc _authenticationBloc =
//         AuthenticationBloc(authenticationService: _authenticationService);

//     // controls the sign in status of the current user
//     return AuthenticationBlocProvider(
//       authenticationBloc: _authenticationBloc,
//       // checks whether the user is premium or not
//       child: StreamBuilder(
//           stream: _authenticationBloc.isUserPremiumStream,
//           initialData: null,
//           builder: (BuildContext context, AsyncSnapshot userStatusSnapshot) {
//             if (userStatusSnapshot.connectionState == ConnectionState.waiting) {
//               return MaterialApp(
//                 home: Scaffold(
//                   body: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               );
//             } else if (userStatusSnapshot.hasData &&
//                 userStatussnapshot.data() == true) {
//               // controls the loading and saving of the user's games
//               return GamesBlocProvider(
//                 gamesBloc: GamesBloc(
//                   cloudFirestoreDatabase: _cloudFirestoreDatabase,
//                   authenticationService: _authenticationService,
//                 ),
//                 // controls the loading, adding and deleting of the user's friends
//                 child: FriendsBlocProvider(
//                   friendsBloc: FriendsBloc(
//                     authenticationService: _authenticationService,
//                     cloudFirestoreDatabase: _cloudFirestoreDatabase,
//                   ),
//                   // the app for premium user
//                   child: LocalGamesBlocProvider(
//                     localGamesBloc: LocalGamesBloc(),
//                     child: MaterialApp(
//                       debugShowCheckedModeBanner: true,
//                       theme: theme,
//                       // TODO: enable darkTheme when darkmode is implemented
//                       // darkTheme: darkTheme,
//                       home: StreamBuilder(
//                           initialData: null,
//                           // based on the user's authentication status either Home() or SignUp() is being built
//                           stream: _authenticationBloc.user,
//                           builder: (BuildContext context,
//                               AsyncSnapshot userAuthenticationSnapshot) {
//                             // _authenticationBloc.startListeners();
//                             // loading icon while checking the user's authentication status
//                             if (userAuthenticationSnapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Container(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             // is executed if the user is authenticated
//                             else if (userAuthenticationSnapshot.hasData) {
//                               return HomePremium();
//                             }
//                             // is executed if the user isn't authenticated
//                             else {
//                               return SignUp();
//                             }
//                           }),
//                     ),
//                   ),
//                 ),
//               );
//             } else {
//               // the app for non premium user
//               return LocalGamesBlocProvider(
//                 localGamesBloc: LocalGamesBloc(),
//                 child: MaterialApp(
//                   debugShowCheckedModeBanner: true,
//                   theme: theme,
//                   darkTheme: darkTheme,
//                   home: Home(),
//                 ),
//               );
//             }
//           }),
//     );
//   }
// }
