// gameTypeSelection.dart
import "../../imports.dart";

class GameTypeSelection extends StatefulWidget {
  @override
  _GameTypeSelectionState createState() => _GameTypeSelectionState();
}

class _GameTypeSelectionState extends State<GameTypeSelection> {
  Widget currentPage;

  

  @override
  void initState() {
    super.initState();
    this.currentPage = Scaffold(
      appBar: AppBar(
        title: Text("Partie erstellen"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: RaisedButton(
                  child: Text(
                    "Gegen einen Freund spielen",
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () => createGamePremium(),
                ),
              ),
              Flexible(
                child: RaisedButton(
                  child: Text(
                    "Offline Partie erstellen",
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () => createOfflineGame(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createGamePremium() {
    setState(() {
      this.currentPage = CreateGamePremium();
    });
  }

  void createOfflineGame() {
    setState(() {
      this.currentPage = CreateGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}
