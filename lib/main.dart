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
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: theme,
      darkTheme: darkTheme,
      home: AuthenticationBlocProvider(
        authenticationBloc: _authenticationBloc,
        // checks whether the user is premium or not
        child: StreamBuilder(
            stream: _authenticationBloc.isUserPremiumStream,
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot firstSnapshot) {
              if (firstSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: CircularProgressIndicator(),
                );
              } else if (firstSnapshot.hasData && firstSnapshot.data == true) {
                // controls the loading and saving of the user's games
                return GameBlocProvider(
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
                    child: StreamBuilder(
                        initialData: null,
                        // based on the user's authentication status either Home() or SignUp() is being built
                        stream: _authenticationBloc.user,
                        builder: (BuildContext context,
                            AsyncSnapshot secondSnapshot) {
                          // loading icon while checking the user's authentication status
                          if (secondSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // is executed if the user is authenticated
                          else if (secondSnapshot.hasData) {
                            return Home(
                              isUserPremium: firstSnapshot.data,
                            );
                          }
                          // is executed if the user isn't authenticated
                          else {
                            return SignUp();
                          }
                        }),
                  ),
                );
              } else {
                return LocalGamesBlocProvider(
                  localGamesBloc: LocalGamesBloc(),
                  child: Home(
                    isUserPremium: firstSnapshot.data,
                  ),
                );
              }
            }),
      ),
    );
  }
}
