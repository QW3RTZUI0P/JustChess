// createGameButton.dart
import "../../../imports.dart";

class CreateGameButton extends StatefulWidget {
  @override
  _CreateGameButtonState createState() => _CreateGameButtonState();
}

class _CreateGameButtonState extends State<CreateGameButton> {
  LocalGamesBloc _localGamesBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localGamesBloc = LocalGamesBlocProvider.of(context).localGamesBloc;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        tooltip: "Neue Partie hinzufügen",
        onPressed: () {
          // TODO: make limit: not more than 200 games or so

          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return CreateGame(
                  isUserPremium: false,
                );
              },
            ),
          );
        });
  }
}
