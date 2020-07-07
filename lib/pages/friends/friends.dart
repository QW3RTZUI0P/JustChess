// friends.dart
import "../../imports.dart";

// TODO: enable auto reload after adding a friend
class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  FriendsBloc _friendsBloc;
  GameBloc _gameBloc;

  @override
  void initState() {
    super.initState();
    this._friendsBloc = FriendsBloc(
      authenticationService: AuthenticationService(),
      cloudFirestoreDatabase: CloudFirestoreDatabase(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Freunde"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    maintainState: true,
                    builder: (BuildContext context) {
                      return FindNewFriend();
                    }),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _friendsBloc.friendsListStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text("Noch keine Freunde hinzugefügt"),
            );
          } else if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    snapshot.data[index],
                  ),
                  // TODO: besseres Icon finden
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return CreateGame(
                              opponent: snapshot.data[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: snapshot.data.length,
            );
          }
        },
      ),
    );
  }
}
