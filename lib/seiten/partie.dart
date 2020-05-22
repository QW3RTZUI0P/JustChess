// partie.dart
import "../imports.dart";

class Partie extends StatefulWidget {
  Partie({
    this.aktuellePartie,
  });

  final PartieKlasse aktuellePartie;

  @override
  _PartieState createState() => _PartieState();
}

class _PartieState extends State<Partie> {
  ChessBoardController chessBoardController = ChessBoardController();

  @override
  Widget build(BuildContext context) {
    PartienProvider partienProvider = Provider.of<PartienProvider>(context);

    PartieKlasse aktuellePartieImState = widget.aktuellePartie;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aktuellePartie.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChessBoard(
              onMove: (move) {
                String pgn = chessBoardController.game.pgn();
                aktuellePartieImState.pgn = pgn;
              },
              onCheckMate: (color) {
                print(color);
              },
              onDraw: () {},
              size: MediaQuery.of(context).size.width * 0.8,
              enableUserMoves: true,
              chessBoardController: chessBoardController,
            ),
            RaisedButton(
              child: Text("Lade Partie"),
              onPressed: () {
                chessBoardController.loadPGN(
                  widget.aktuellePartie.pgn,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
