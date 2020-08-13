// createOnlineGame.dart
import 'dart:math';
import '../../imports.dart';

// page that is shown when CreateGameButton has been pressed
class CreateOnlineGame extends StatefulWidget {
  final String selectedFriend;
  CreateOnlineGame({this.selectedFriend = ""});
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
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _neuePartieNameController,
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
                    onChanged: (value) => radioButtonChanged(value),
                    groupValue: radioButtonGroupValue,
                  ),
                  Text("Zufällige Farbauswahl"),
                ],
              ),
              StreamBuilder<Object>(
                  stream: _friendsBloc.friendsListStream,
                  initialData: _friendsBloc.friendsList,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null ||
                        !snapshot.hasData ||
                        snapshot.data == [] ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text(
                          "Noch keine Freunde hinzugefügt",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]),
                            selected:
                                this.selectedFriend == snapshot.data[index],
                            onTap: () {
                              setState(() {
                                this.selectedFriend = snapshot.data[index];
                              });
                            },
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
