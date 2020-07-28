// createGamePremium.dart
import "../../imports.dart";

// Dialog der angezeigt wird, wenn der PartieErstellenButton gedrückt wird
// TODO: enable auto generated names
class CreateGamePremium extends StatefulWidget {
  @override
  _CreateGamePremiumState createState() => _CreateGamePremiumState();
}

class _CreateGamePremiumState extends State<CreateGamePremium> {
  GamesBloc _gameBloc;
  FriendsBloc _friendsBloc;

  TextEditingController _neuePartieNameController = TextEditingController();
  int radioButtonGroupValue = 0;
  bool benutzerIstWeiss = true;

  // the friend the user wants to play against
  String selectedFriend = "";

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
      print(benutzerIstWeiss.toString());
    } else {
      setState(() {
        this.benutzerIstWeiss = false;
        this.radioButtonGroupValue = 1;
        print(benutzerIstWeiss.toString());
      });
    }
  }

  void createGame() async {
    String opponentID = await _gameBloc.cloudFirestoreDatabase
        .getUserIDForUsername(username: this.selectedFriend);
    GameClass neuePartie = GameClass(
      title: _neuePartieNameController.text,
      pgn: "",
      player01: _gameBloc.currentUserID,
      player01IsWhite: this.benutzerIstWeiss,
      player02: opponentID,
      moveCount: 0,
      canBeDeleted: false,
    );
    neuePartie.createUniqueID();
    _gameBloc.addGameSink.add(neuePartie);

    _neuePartieNameController.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partie erstellen"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Partie erstellen"),
        shape: CircleBorder(side: BorderSide()),
        tooltip: "Partie erstellen",
        onPressed: () => createGame(),
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
              StreamBuilder<Object>(
                  stream: _friendsBloc.friendsListStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null ||
                        !snapshot.hasData ||
                        snapshot.data == []) {
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
                            selected: this.selectedFriend == snapshot.data[index],
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