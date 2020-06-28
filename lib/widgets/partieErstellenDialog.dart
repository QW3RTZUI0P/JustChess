// partieErstellenDialog.dart
import "../imports.dart";

// Dialog der angezeigt wird, wenn der PartieErstellenButton gedrückt wird
class PartieErstellenDialog extends StatefulWidget {

  GameBloc gameBloc;
  PartieErstellenDialog({this.gameBloc});

  @override
  _PartieErstellenDialogState createState() => _PartieErstellenDialogState();
}

class _PartieErstellenDialogState extends State<PartieErstellenDialog> {

  TextEditingController _neuePartieNameController = TextEditingController();
  int radioButtonGroupValue = 0;
  bool benutzerIstWeiss = true;

  void radioButtonChanged(int value) {
    if (value == 0) {
      setState(() {
        this.benutzerIstWeiss = true;
        this.radioButtonGroupValue = 0;
      });
      print(benutzerIstWeiss.toString());
    } else {
      setState(() {
        this.benutzerIstWeiss = false;
        this.radioButtonGroupValue = 1;
        print(benutzerIstWeiss.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _neuePartieNameController,
            decoration: InputDecoration(hintText: "der Name der Partie"),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Ich bin"),
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 0,
                onChanged: (value) => radioButtonChanged(value),
                groupValue: radioButtonGroupValue,
              ),
              Text("Weiß"),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 1,
                onChanged: (value) => radioButtonChanged(value),
                groupValue: radioButtonGroupValue,
              ),
              Text("Schwarz"),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Erstellen"),
          onPressed: () async {
            PartieKlasse neuePartie = PartieKlasse(
              name: _neuePartieNameController.text,
              pgn: "",
              player01: widget.gameBloc.currentUserID,
              player01IsWhite: this.benutzerIstWeiss,
              moveCount: 0,
            );
            widget.gameBloc.addGame(game: neuePartie,);
            _neuePartieNameController.text = "";
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
