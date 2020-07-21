// createGameButton.dart
import "../imports.dart";

class CreateGameButton extends StatefulWidget {
  bool isUserPremium;
  CreateGameButton({@required this.isUserPremium});
  @override
  _CreateGameButtonState createState() => _CreateGameButtonState();
}

class _CreateGameButtonState extends State<CreateGameButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
      ),
      tooltip: "Neue Partie hinzufügen",
      onPressed: () {
        widget.isUserPremium
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) {
                    // TODO: decide whether to show the list of friends when creating a new game
                    // or to show a separate page
                    // TODO: make friensBloc lazy or something like this, so that it doesn't fetch the friends list all the time
                    return GameTypeSelection();
                    // return PartieErstellen();
                  },
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) {
                      return CreateGame();
                    }),
              );
      },
    );
  }
}
