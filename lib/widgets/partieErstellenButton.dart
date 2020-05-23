// partieErstellenButton.dart
import "../imports.dart";

class PartieErstellenButton extends StatefulWidget {

  @override
  _PartieErstellenButtonState createState() => _PartieErstellenButtonState();
}

class _PartieErstellenButtonState extends State<PartieErstellenButton> {
  TextEditingController _neuePartieNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    PartienProvider partienProvider = Provider.of<PartienProvider>(context);

    return IconButton(
      icon: Icon(
        Icons.add,
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: TextField(
                  controller: _neuePartieNameController,
                  decoration: InputDecoration(hintText: "der Name der Partie"),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Erstellen"),
                    onPressed: () {
                      PartieKlasse neuePartie = PartieKlasse(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _neuePartieNameController.text,
                        pgn: "",
                      );
                      partienProvider.neuePartieErstellt(partie: neuePartie);
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Abbrechen"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            });
      },
    );
  }
}
