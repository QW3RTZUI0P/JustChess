// createGameButtonPremium.dart
import '../../../imports.dart';

class CreateGameButtonPremium extends StatefulWidget {
  @override
  _CreateGameButtonPremiumState createState() =>
      _CreateGameButtonPremiumState();
}

class _CreateGameButtonPremiumState extends State<CreateGameButtonPremium> {
  GamesBloc _gamesBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        tooltip: "Neue Partie hinzufügen",
        onPressed: () {
          if (_gamesBloc.gameIDsList.length >= 30) {
            SnackbarMessage(
                    context: context,
                    message:
                        "Du kannst nicht mehr als 30 Online Partien hinzufügen.")
                .showSnackBar();
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                // TODO: make friensBloc lazy or something like this, so that it doesn't fetch the friends list all the time
                return GameTypeSelection();
              },
            ),
          );
        });
  }
}
