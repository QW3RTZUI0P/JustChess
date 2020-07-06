// friends.dart
import "../imports.dart";

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
      cloudFirestoreDatabase: CloudFirestoreDatabase(),
      authenticationService: AuthenticationService(),
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
              Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (BuildContext context) {
                return FindNewFriend(friendsBloc: this._friendsBloc,);
              }),);
              // TextEditingController _newFriendController =
              //     TextEditingController();
              // showDialog(
              //   context: context,
              //   builder: (_) => AlertDialog(
              //     content: TextField(
              //       controller: _newFriendController,
              //       decoration:
              //           InputDecoration(hintText: "der Name des Freundes"),
              //     ),
              //     actions: <Widget>[
              //       FlatButton(
              //         child: Text("OK"),
              //         onPressed: () {
              //           this
              //               ._gameBloc
              //               .cloudFirestoreDatabase
              //               .addFriendToFirestore(
              //                 userID: _gameBloc.currentUserID,
              //                 nameOfTheFriend: _newFriendController.text,
              //               );
              //               Navigator.pop(context);
              //         },
              //       ),
              //       FlatButton(
              //         child: Text("Abbrechen"),
              //         onPressed: () => Navigator.pop(context),
              //       ),
              //     ],
              //   ),
              // );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _friendsBloc.friendsList,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return PartieErstellen(
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
