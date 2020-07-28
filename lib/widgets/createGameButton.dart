// createGameButton.dart
import "../imports.dart";

class CreateGameButton extends StatefulWidget {
  final bool isUserPremium;
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
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return widget.isUserPremium
                  ?
                  // TODO: make friensBloc lazy or something like this, so that it doesn't fetch the friends list all the time
                  GameTypeSelection()
                  : CreateGame(
                      isUserPremium: false,
                    );
            },
          ),
        );
      },
    );
  }
}
