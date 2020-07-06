// findNewFriend.dart

import "../imports.dart";

class FindNewFriend extends StatefulWidget {
  final FriendsBloc friendsBloc;
  FindNewFriend({this.friendsBloc});

  @override
  _FindNewFriendState createState() => _FindNewFriendState(
        usernames: friendsBloc.usernamesList,
      );
}

// TODO: think about bug which occurs when writing this.usernames = friendsBloc.usernamesList
class _FindNewFriendState extends State<FindNewFriend> {
  FriendsBloc friendsBloc;
  GameBloc _gameBloc;
  List<String> searchResults = [];
  final List<String> usernames;
  _FindNewFriendState({this.usernames}) {
    print("construct");
  }

  // TextEditingController for the search bar at the top
  TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: make this better so that it uses the bloc from the widget ubove in the tree (or make a provider)
    this.friendsBloc = widget.friendsBloc;
    this.searchResults = List.from(this.friendsBloc.usernamesList);

    print("usernames init: " + this.usernames.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  void searchFor(String query) {
    List<String> usernamesInFunction = [];
    usernamesInFunction.addAll(this.usernames);
    if (query.isNotEmpty) {
      List<String> searchResultsInFunction = [];
      for (String currentUser in usernamesInFunction) {
        print("for");
        if (currentUser.contains(
          query,
        )) {
          searchResultsInFunction.add(
            currentUser,
          );
        }
      }
      print("usernames in between: " + this.usernames.toString());
      // return;
      setState(() {
        searchResults.clear();
        searchResults.addAll(searchResultsInFunction);
      });
      print("searchResult: " + searchResults.toString());
      print("searchResultInFunction: " + searchResultsInFunction.toString());
      print("usernames: " + this.usernames.toString());
      print("friendsBloc Usernames: " +
          widget.friendsBloc.usernamesList.toString());
    } else {
      print("else");
      setState(() {
        searchResults.clear();
        searchResults.addAll(this.usernames);
      });
    }
  }

  void addNewFriend({@required String name}) {
    friendsBloc.cloudFirestoreDatabase.addFriendToFirestore(
        userID: _gameBloc.currentUserID, nameOfTheFriend: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // TODO: make the search bar lazy, so that it fetches only the necessary values
            TextField(
              controller: _searchBarController,
              onChanged: (String query) => searchFor(query),
              decoration: InputDecoration(
                labelText: "Suche",
                hintText: "Name des Freundes",
                prefixIcon: Icon(Icons.search),
              ),
            ),

            // advantage: this ListView builds only the ListTiles the user can see
            Expanded(
              child: ListView.builder(
                  // children: <Widget>[ListTile(title: Text(availableFriends[0]))],
                  itemCount: searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        searchResults[index],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          addNewFriend(
                            name: searchResults[index],
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     fullscreenDialog: true,
                          //     builder: (BuildContext context) {
                          //       return PartieErstellen(
                          //         opponent: searchResults[index],
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
