// findNewFriend.dart

import "../../../imports.dart";

// TODO: show list of all available friends in the beginning

class FindNewFriend extends StatefulWidget {
  @override
  _FindNewFriendState createState() => _FindNewFriendState();
}

class _FindNewFriendState extends State<FindNewFriend>
    with AfterLayoutMixin<FindNewFriend> {
  FriendsBloc _friendsBloc;
  // the search results shown in the list
  List<String> searchResults = [];
  // TextEditingController for the search bar at the top
  TextEditingController _searchBarController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._friendsBloc = FriendsBlocProvider.of(context).friendsBloc;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // this._friendsBloc.loadAvailableFriends();
    // setState(() {
    //   print(_friendsBloc.availableFriendsList.toString());
    //   // has to be this way, otherwise when searchResults changes, the availableFriendsHelperList would also change
    //   this.searchResults = List.from(_friendsBloc.availableFriendsList);
    // });
  }

  void addNewFriend({@required String name}) {
    _friendsBloc.addedFriendSink.add(name);
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
                      searchFor(query, inList: _friendsBloc.availableFriendsList),
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
                            onTap: () {
                              addNewFriend(name: searchResults[index]);
                              Navigator.pop(context);
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                addNewFriend(
                                  name: searchResults[index],
                                );
                                // think about this
                                // is it good that the page dissappears when the user added a friend or is it confusing
                                // TODO: maybe add a nice animation so that it's clear
                                Navigator.pop(context);
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
