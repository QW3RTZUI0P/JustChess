// createOnlineGame.dart
import 'dart:math';
import '../../imports.dart';

// page that is shown when CreateGameButton has been pressed
class CreateOnlineGame extends StatefulWidget {
  final String selectedFriend;
  CreateOnlineGame({
    this.selectedFriend = "",
  });
  @override
  _CreateOnlineGameState createState() => _CreateOnlineGameState();
}

class _CreateOnlineGameState extends State<CreateOnlineGame> {
  GamesBloc _gameBloc;
  FriendsBloc _friendsBloc;

  TextEditingController _neuePartieNameController = TextEditingController();
  int radioButtonGroupValue = 0;
  bool benutzerIstWeiss = true;

  // the friend the user wants to play against
  String selectedFriend = "";

  @override
  void initState() {
    super.initState();
    this.selectedFriend = widget.selectedFriend;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GamesBlocProvider.of(context).gamesBloc;
    this._friendsBloc = FriendsBlocProvider.of(context).friendsBloc;
    this._friendsBloc.loadFriends();
  }

  void radioButtonChanged(int value) {
    if (value == 0) {
      setState(() {
        this.benutzerIstWeiss = true;
        this.radioButtonGroupValue = 0;
      });
    } else if (value == 1) {
      setState(() {
        this.benutzerIstWeiss = false;
        this.radioButtonGroupValue = 1;
      });
    } else {
      Random random = Random();
      setState(() {
        this.benutzerIstWeiss = random.nextBool();
        this.radioButtonGroupValue = 2;
      });
    }
  }

  // TODO: store a Map<FriendName, FriensUserID> locallly ont the device
  void createGame(BuildContext currentContext) async {
    if (this.selectedFriend == "") {
      SnackbarMessage(
              context: currentContext, message: "Bitte wähle einen Freund")
          .showSnackBar();
      return;
    }
    String opponentID = await _gameBloc.cloudFirestoreDatabase
        .getUserIDForUsername(username: this.selectedFriend);
    GameClass neuePartie = GameClass(
      title: _neuePartieNameController.text,
      pgn: "",
      player01: _gameBloc.currentUserID,
      player01IsWhite: this.benutzerIstWeiss,
      player02: opponentID,
      moveCount: 0,
      gameStatus: GameStatus.playing,
      isOnline: true,
      canBeDeleted: false,
    );
    neuePartie.createUniqueID();
    _gameBloc.addGameSink.add(neuePartie);

    _neuePartieNameController.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Partie erstellen"),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext currentContext) => FloatingActionButton.extended(
          label: Text("Partie erstellen"),
          tooltip: "Partie erstellen",
          onPressed: () => createGame(currentContext),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextField(
                controller: _neuePartieNameController,
                maxLength: 100,
                decoration:
                    InputDecoration(hintText: "der Untertitel der Partie"),
              ),
              // TextField(
              //   controller: _opponentController,
              //   decoration: InputDecoration(hintText: "der Gegener"),
              // ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Ich spiele als"),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 0,
                    activeColor: theme.primaryColor,
                    onChanged: (value) => radioButtonChanged(value),
                    groupValue: radioButtonGroupValue,
                  ),
                  Text("Weiß"),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    activeColor: theme.primaryColor,
                    onChanged: (value) => radioButtonChanged(value),
                    groupValue: radioButtonGroupValue,
                  ),
                  Text("Schwarz"),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 2,
                    activeColor: theme.primaryColor,
                    onChanged: (value) => radioButtonChanged(value),
                    groupValue: radioButtonGroupValue,
                  ),
                  Text("Zufällige Farbauswahl"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Gegner auswählen:",
                      style: theme.textTheme.headline6)),
              const SizedBox(
                height: 10,
              ),
              _friendsBloc.friendsList.length == 0
                  ? Center(
                      child: Text("Noch keine Freunde hinzugefügt"),
                    )
                  : Expanded(
                      child: ListView.builder(
                          // shrinkWrap: true,

                          itemCount: _friendsBloc.friendsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_friendsBloc.friendsList[index]),
                              tileColor: selectedFriend ==
                                      _friendsBloc.friendsList[index]
                                  ? theme.focusColor
                                  : null,
                              onTap: () {
                                setState(() {
                                  this.selectedFriend =
                                      _friendsBloc.friendsList[index];
                                });
                              },
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
