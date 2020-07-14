// main.dart
import "imports.dart";

void main() => runApp(JustChess());

class JustChess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // class with all the methods needed for authentication
    final AuthenticationService _authenticationService =
        AuthenticationService();
    // class with all the methods needed for reading and writing from and to CloudFirestore
    final CloudFirestoreDatabaseApi _cloudFirestoreDatabase =
        CloudFirestoreDatabase();

    // has to be local variable because its values are being used in the StreamBuilder below
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(authenticationService: _authenticationService);

    // controls the sign in status of the current user
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      // controls the loading and saving of the user's games
      child: GameBlocProvider(
        gameBloc: GameBloc(
          cloudFirestoreDatabase: _cloudFirestoreDatabase,
          authenticationService: _authenticationService,
        ),
        // controls the loading, adding and deleting of the user's friends
        child: FriendsBlocProvider(
          friendsBloc: FriendsBloc(
            authenticationService: _authenticationService,
            cloudFirestoreDatabase: _cloudFirestoreDatabase,
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: true,
            // from /other/theme.dart
            theme: theme,
            darkTheme: darkTheme,
            home: StreamBuilder(
                initialData: null,
                // based on the user's authentication status either Home() or SignUp() is being built
                stream: _authenticationBloc.user,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // loading icon while checking the user's authentication status
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // is executed if the user is authenticated
                  else if (snapshot.hasData) {
                    return Home();
                  }
                  // is executed if the user isn't authenticated
                  else {
                    return SignUp();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
