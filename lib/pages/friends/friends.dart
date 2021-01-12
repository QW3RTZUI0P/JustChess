// friends.dart
import "../../imports.dart";

// TODO: enable auto reload after adding a friend
class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with AfterLayoutMixin<Friends> {
  FriendsBloc _friendsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._friendsBloc = FriendsBlocProvider.of(context).friendsBloc;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _friendsBloc.loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    print("building friends");
    print(_friendsBloc.friendsList.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Freunde"),
        actions: <Widget>[
          Builder(
            builder: (BuildContext currentContext) => IconButton(
              icon: Icon(Icons.person_add),
              tooltip: "Neuen Freund hinzufügen",
              onPressed: () {
                if (_friendsBloc.friendsList.length > 20) {
                  SnackbarMessage(
                          context: currentContext,
                          message:
                              "Du kannst nicht mehr als zwanzig Freunde hinzufügen")
                      .showSnackBar();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      maintainState: true,
                      builder: (BuildContext context) {
                        print("q " +
                            _friendsBloc.availableFriendsList.toString());
                        return FindNewFriend();
                      }),
                );
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _friendsBloc.friendsListStream,
        initialData: _friendsBloc.friendsList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(
              child: Text("Noch keine Freunde hinzugefügt"),
            );
          } else {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data[index]),
                  background: Icon(Icons.delete),
                  onDismissed: (_) {
                    _friendsBloc.deletedFriendSink.add(snapshot.data[index]);
                  },
                  child: ListTile(
                    title: Text(
                      snapshot.data[index],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return CreateOnlineGame(
                              selectedFriend: snapshot.data[index],
                            );
                          },
                        ),
                      );
                    },
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
                              return CreateOnlineGame(
                                selectedFriend: snapshot.data[index],
                              );
                            },
                          ),
                        );
                      },
                    ),
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
