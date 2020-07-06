// partieErstellen.dart
import "../imports.dart";

// Dialog der angezeigt wird, wenn der PartieErstellenButton gedrückt wird
class PartieErstellen extends StatefulWidget {
  final String opponent;
  PartieErstellen({this.opponent});

  @override
  _PartieErstellenState createState() => _PartieErstellenState();
}

class _PartieErstellenState extends State<PartieErstellen> {
  GameBloc _gameBloc;

  TextEditingController _neuePartieNameController = TextEditingController();
  int radioButtonGroupValue = 0;
  bool benutzerIstWeiss = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
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
        .getUserIDForUsername(username: widget.opponent);
    PartieKlasse neuePartie = PartieKlasse(
      name: _neuePartieNameController.text,
      pgn: "",
      player01: _gameBloc.currentUserID,
      player01IsWhite: this.benutzerIstWeiss,
      player02: opponentID,
      moveCount: 0,
      canBeDeleted: false,
    );
    neuePartie.erstelleID();
    _gameBloc.addGameSink.add(neuePartie);
    // if (widget.opponent.isEmpty == false) {
    //   String opponentsUserID = await _gameBloc.cloudFirestoreDatabase
    //       .getUserIDForUsername(username: widget.opponent);
    //   neuePartie.player02 = opponentsUserID;
    //   _gameBloc.cloudFirestoreDatabase
    //       .addGameIDToFirestore(userID: opponentsUserID, gameID: neuePartie.id);
    // }r
    _neuePartieNameController.text = "";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partie erstellen"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _neuePartieNameController,
                decoration: InputDecoration(hintText: "der Name der Partie"),
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
                child: Text("Ich bin"),
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
              FlatButton(
                child: Text("Erstellen"),
                onPressed: () => createGame(),
              ),
              FlatButton(
                child: Text("Abbrechen"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
