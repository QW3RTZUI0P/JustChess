// createOfflineGame.dart
import "../imports.dart";

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  // bloc that manages the local saving of the games
  LocalGamesBloc _localGamesBloc;
  // TextEditingcontroller for the name of the created game
  TextEditingController _nameController = TextEditingController();
  // holds the value of the RadioButtons
  bool _radioGroupValue = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._localGamesBloc = LocalGamesBlocProvider.of(context).localGamesBloc;
  }

  void radioButtonChanged({bool toValue}) {
    setState(() {
      _radioGroupValue = toValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Neue Partie erstellen"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            children: <Widget>[
              TextField(
                maxLength: 100,
                decoration: InputDecoration(labelText: "Name der Partie"),
                controller: _nameController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Ich spiele als",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Radio(
                    value: true,
                    groupValue: _radioGroupValue,
                    onChanged: (value) => radioButtonChanged(toValue: value),
                  ),
                  Expanded(child: Text("Weiß")),
                  Radio(
                    value: false,
                    groupValue: _radioGroupValue,
                    onChanged: (value) => radioButtonChanged(toValue: value),
                  ),
                  Expanded(child: Text("Schwarz"))
                ],
              ),
              RaisedButton(
                child: Text("Partie erstellen"),
                onPressed: () async {
                  GameClass newGame = GameClass(
                    subtitle: _nameController.text,
                    player01IsWhite: _radioGroupValue,
                  );
                  print("newGame " + newGame.subtitle);
                  newGame.erstelleID();
                  _localGamesBloc.localGameCreated(
                    newGame: newGame,
                  );
                  print(await LocalDatabaseFileRoutines().readFileAsString());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
