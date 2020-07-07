// findNewFriend.dart

import "../../imports.dart";

// TODO: show list of all available friends in the beginning

class FindNewFriend extends StatefulWidget {

  @override
  _FindNewFriendState createState() => _FindNewFriendState();
}

class _FindNewFriendState extends State<FindNewFriend> {
  FriendsBloc _friendsBloc;
  GameBloc _gameBloc;
  // the search results shown in the list
  List<String> searchResults = [];
  // TextEditingController for the search bar at the top
  TextEditingController _searchBarController = TextEditingController();

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

  void addNewFriend({@required String name}) {
    _friendsBloc.cloudFirestoreDatabase.addFriendToFirestore(
        userID: _gameBloc.currentUserID, nameOfTheFriend: name);
  }

  @override
  Widget build(BuildContext context) {
    // the function that searches the list of available friends
    void searchFor(
      String query, {
      @required List<String> inList,
    }) {
      List<String> availableFriendsInFunction = [];
      availableFriendsInFunction.addAll(inList);
      if (query.isNotEmpty) {
        List<String> searchResultsInFunction = [];
        for (String currentUser in availableFriendsInFunction) {
          print("for");
          if (currentUser.contains(
            query,
          )) {
            searchResultsInFunction.add(
              currentUser,
            );
          }
        }
        setState(() {
          searchResults.clear();
          searchResults.addAll(searchResultsInFunction);
        });
      } else {
        print("else");
        setState(() {
          searchResults.clear();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder(
          stream: _friendsBloc.availableFriendsListStream,
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("snapshot data: " + snapshot.data.toString());
            return Column(
              children: <Widget>[
                // TODO: make the search bar lazy, so that it fetches only the necessary values
                TextField(
                  controller: _searchBarController,
                  onChanged: (String query) =>
                      searchFor(query, inList: snapshot.data),
                  decoration: InputDecoration(
                    labelText: "Suche",
                    hintText: "Name des Freundes",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),

                // advantage: this ListView builds only the ListTiles the user can see
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
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
                              },
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
