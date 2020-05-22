// neuePartieButton.dart
import "../imports.dart";

class NeuePartieButton extends StatefulWidget {
  @override
  _NeuePartieButtonState createState() => _NeuePartieButtonState();
}

class _NeuePartieButtonState extends State<NeuePartieButton> {
  TextEditingController neuePartieController = TextEditingController();

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
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: Text("Erstellen"),
                    onPressed: () {
                      PartieKlasse neuePartieErstellt = PartieKlasse(
                        name: neuePartieController.text,
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        pgn: "",
                      );
                      print("pups");
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Abbrechen"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                content: TextField(
                  controller: neuePartieController,
                  decoration:
                      InputDecoration(hintText: "Name der neuen Partie"),
                ),
              );
            });
      },
    );
  }
}
