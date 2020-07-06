// partieErstellenButton.dart
import "../imports.dart";

class PartieErstellenButton extends StatefulWidget {
  final GameBloc gameBloc;
  PartieErstellenButton({this.gameBloc});

  @override
  _PartieErstellenButtonState createState() => _PartieErstellenButtonState();
}

class _PartieErstellenButtonState extends State<PartieErstellenButton> {
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
              // TODO: decide whether to show the list of friends when creating a new game
              // or to show a separate page
              // TODO: make friensBloc lazy or something like this, so that it doesn't fetch the friends list all the time
              return Friends();
              // return PartieErstellen();
            },
          ),
        );
      },
    );
  }
}
