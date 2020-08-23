// friendsBloc.dart

import "../imports.dart";

class FriendsBloc {
  // values for Authentication and CloudFirestore
  final CloudFirestoreDatabaseApi cloudFirestoreDatabase;
  final AuthenticationApi authenticationService;

  // the username of the current user
  String username = "";
  // the userID of the current user
  String userID = "";
  // List with all usernames, also with the one of the current user and the ones of himself
  List<String> usernamesList = [];
  // List which gets added every friends when all friends are added at the start
  // during runtime this has all the user's friends
  List<String> friendsList = [];
  // helper list for available friends
  // during runtime it has all the available friends for the user
  List<String> availableFriendsList = [];

  FriendsBloc({
    this.cloudFirestoreDatabase,
    this.authenticationService,
  }) {
    _startListeners();
    getImportantValues();
  }

  // controls every added friend and passes the updated List to the friendsListController
  StreamController<dynamic> friendsController = StreamController<dynamic>();
  Sink<dynamic> get friendSink => friendsController.sink;
  Stream<dynamic> get friendStream => friendsController.stream;

  // controls the current List of friends
  StreamController<List<dynamic>> friendsListController =
      StreamController<List<dynamic>>.broadcast();
  Sink<List<dynamic>> get friendsListSink => friendsListController.sink;
  Stream<List<dynamic>> get friendsListStream => friendsListController.stream;

  // TODO: make this StreamController lazy so that it only fetches the friends the user searched for
  // controls all the available friends
  StreamController<List<dynamic>> availableFriendsListController =
      StreamController<List<dynamic>>.broadcast();
  Sink<List<dynamic>> get availableFriendsListSink =>
      availableFriendsListController.sink;
  Stream<List<dynamic>> get availableFriendsListStream =>
      availableFriendsListController.stream;

  // controls all the added friends
  StreamController<dynamic> addedFriendController = StreamController<dynamic>();
  Sink<dynamic> get addedFriendSink => addedFriendController.sink;
  Stream<dynamic> get addedFriendStream => addedFriendController.stream;

  // controls all the deleted friends
  StreamController<dynamic> deletedFriendController =
      StreamController<dynamic>();
  Sink<dynamic> get deletedFriendSink => deletedFriendController.sink;
  Stream<dynamic> get deletedFriendStream => deletedFriendController.stream;

  // is being executed in the constructor
  // sets up the listeners necessary for the StreamControllers to work
  void _startListeners() {
    // gets called when a friend is fetched from the user's document in CloudFirestore
    this.friendStream.listen((newFriend) async {
      this.friendsList.add(newFriend);
      this.friendsListSink.add(this.friendsList);
    });
    this.friendsListStream.listen((newFriendsList) {
      availableFriendsList = List.from(this.usernamesList);
      // removes the added friends from the availableFriends list
      for (String currentFriend in newFriendsList) {
        availableFriendsList.remove(currentFriend);
      }
      // removes the own username from the availableFriends list
      availableFriendsList.remove(this.username);
      this.availableFriendsListSink.add(availableFriendsList);
    });

    addedFriendStream.listen((addedFriend) {
      // removes friend from available friends list
      this.availableFriendsList.remove(addedFriend);
      this.availableFriendsListSink.add(this.availableFriendsList);
      // adds friend to friends list
      this.friendSink.add(addedFriend);
      // adds a new friend to cloud firestore
      this.cloudFirestoreDatabase.addFriendToFirestore(
          userID: this.userID, nameOfTheFriend: addedFriend);
    });

    deletedFriendStream.listen((deletedFriend) {
      // adds friend to available friends list
      this.availableFriendsList.add(deletedFriend);
      this.availableFriendsListSink.add(this.availableFriendsList);
      // deletes friend from friends list
      this.friendsList.remove(deletedFriend);
      this.friendsListSink.add(this.friendsList);
      // deletes friend from cloud firestore
      this.cloudFirestoreDatabase.deleteFriendFromFirestore(
          userID: this.userID, nameOfTheFriend: deletedFriend);
    });
  }

  // closes all the StreamControllers
  void dispose() {
    friendsController.close();
    friendsListController.close();
    availableFriendsListController.close();
    addedFriendController.close();
    deletedFriendController.close();
  }

  // gets the important values
  void getImportantValues() async {
    dynamic user = await authenticationService.currentUser();
    // only executes when the user is signed in
    if (user != null) {
      // gets the userID
      this.userID = await authenticationService.currentUserUid();
      // gets the current User's username
      this.username = await cloudFirestoreDatabase.getUsernameForUserID(
          userID: this.userID);
      // gets the usernames list from the users collection
      this.usernamesList = await cloudFirestoreDatabase.getUsernamesList();
      // gets the friends list
      List<dynamic> friendsListInFunction =
          await cloudFirestoreDatabase.getFriendsList(userID: userID);
      for (String currentFriend in friendsListInFunction) {
        friendsList.add(currentFriend);
      }
    }
  }

  // TODO: check whether this works all the time
  // is called when Friends() loads
  void loadFriends() async {
    // adds all the usernames (except the user's username) to the availableFriendsSink
    if (friendsList.isEmpty) {
      this.availableFriendsList = List.from(this.usernamesList);
      this.availableFriendsList.remove(this.username);
    }
    friendsListSink.add(friendsList ?? []);
  }
  // void loadFriends() async {
  //   // clears the list with the loaded friends (otherwise you'd have multiple times the same friend)
  //   this.friendsList.clear();
  //   // checks if the user has already added any friends
  //   String currentUserID = await authenticationService.currentUserUid();
  //   List<dynamic> friendsListInFunction =
  //       await cloudFirestoreDatabase.getFriendsList(userID: currentUserID) ??
  //           [];
  //   for (String currentFriend in friendsListInFunction) {
  //     this.friendsList.add(currentFriend);
  //   }
  //   // probably unneccesary
  //   // adds all the usernames (except the user's username) to the availableFriendsSink
  //   // if (friendsList.isEmpty) {
  //   //   this.availableFriendsList = List.from(this.usernamesList);
  //   //   this.availableFriendsList.remove(this.username);
  //   // }
  //   // adds all the friends to the StreamTree
  //   friendsListSink.add(this.friendsList ?? []);
  //   // for (dynamic friend in friendsList) {
  //   //   friendSink.add(friend);
  //   // }
  // }

  // is called when FindNewFriend() loads
  void loadAvailableFriends() async {
    this.availableFriendsListSink.add(this.availableFriendsList);
  }
}

// Provider for the friendsBloc
class FriendsBlocProvider extends InheritedWidget {
  final FriendsBloc friendsBloc;
  const FriendsBlocProvider({Key key, Widget child, this.friendsBloc})
      : super(key: key, child: child);
  factory FriendsBlocProvider.of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FriendsBlocProvider>();
  }

  @override
  bool updateShouldNotify(FriendsBlocProvider oldWidget) {
    // returns true if the friendsBloc objects are different from each other
    return this.friendsBloc != oldWidget.friendsBloc;
  }
}
