// friendsBloc.dart

import "../imports.dart";

class FriendsBloc {
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  List<String> usernamesList = [];
  List<String> friendsHelperList = [];
  FriendsBloc({
    this.cloudFirestoreDatabase,
    this.authenticationService,
  }) {
    _startListeners();
    getFriendsList();
    getUsernamesList();
  }

  // controls every added friend and passes the updated List to the friendsListController
  StreamController<dynamic> friendsController = StreamController<dynamic>();
  Sink<dynamic> get _addFriend => friendsController.sink;
  Stream<dynamic> get friends => friendsController.stream;

  // controls the current List of friends
  StreamController<List<dynamic>> friendsListController =
      StreamController<List<dynamic>>();
  Sink<List<dynamic>> get _addFriendsList => friendsListController.sink;
  Stream<List<dynamic>> get friendsList => friendsListController.stream;

  // is being executed in the constructor
  // sets up the listeners necessary for the StreamControllers to work
  void _startListeners() {
    this.friends.listen((newFriend) {
      this.friendsHelperList.add(newFriend);
      _addFriendsList.add(this.friendsHelperList);
    });
  }

  // closes all the StreamControllers
  void dispose() {
    friendsController.close();
    friendsListController.close();
  }

  void getFriendsList() async {
    String currentUserID = await authenticationService.currentUserUid();
    List<dynamic> friendsList =
        await cloudFirestoreDatabase.getFriendsList(userID: currentUserID) ??
            [];
    
    for (dynamic friend in friendsList) {
      _addFriend.add(friend);
      print(friend.toString());
    }
  }

  void getUsernamesList() async {
    this.usernamesList = await cloudFirestoreDatabase.getUsernamesList();
  }
}
