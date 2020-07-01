// partieErstellenButton.dart
import "../imports.dart";

class PartieErstellenButton extends StatefulWidget {
  GameBloc gameBloc;
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
              return PartieErstellen();
            },
          ),
        );
      },
    );
  }
}
