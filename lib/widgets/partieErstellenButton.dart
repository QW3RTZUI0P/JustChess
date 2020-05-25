// partieErstellenButton.dart
import "../imports.dart";

class PartieErstellenButton extends StatefulWidget {
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
        showDialog(
            context: context,
            builder: (context) {
              return PartieErstellenDialog();
            });
      },
    );
  }
}
