// friendsBloc.dart

import "../imports.dart";

class FriendsBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  List<String> friendsHelperList = [];
  FriendsBloc({
    this.cloudFirestoreDatabase,
    this.authenticationService,
  }) {
    _startListeners();
    getFriendsList();
  }

  StreamController<dynamic> friendsController = StreamController<dynamic>();
  Sink<dynamic> get _addFriend => friendsController.sink;
  Stream<dynamic> get friends => friendsController.stream;

  StreamController<List<dynamic>> friendsListController =
      StreamController<List<dynamic>>();
  Sink<List<dynamic>> get _addFriendsList => friendsListController.sink;
  Stream<List<dynamic>> get friendsList => friendsListController.stream;

  void _startListeners() {
    this.friends.listen((newFriend) {
      this.friendsHelperList.add(newFriend);
      _addFriendsList.add(this.friendsHelperList);
    });
  }

  void getFriendsList() async {
    // List<dynamic> friendsList = ["Jürgen", "Hansi", "Opa"];
    String currentUserID = await authenticationService.currentUserUid();
    List<dynamic> friendsList =
        await cloudFirestoreDatabase.getFriends(userID: currentUserID) ?? [];
    for (dynamic friend in friendsList) {
      _addFriend.add(friend);
      print(friend.toString());
    }
  }
}
