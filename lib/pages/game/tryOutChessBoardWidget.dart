// tryOutChessBoardWidget.dart
import "../../imports.dart";

class TryOutChessBoardWidget extends StatefulWidget {
  final String pgn;
  TryOutChessBoardWidget({@required this.pgn});

  @override
  _TryOutChessBoardWidgetState createState() => _TryOutChessBoardWidgetState();
}

class _TryOutChessBoardWidgetState extends State<TryOutChessBoardWidget>
    with AfterLayoutMixin<TryOutChessBoardWidget> {
  ChessBoardController _chessBoardController = ChessBoardController();

  @override
  void afterFirstLayout(BuildContext context) {
    _chessBoardController.loadPGN(widget.pgn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ChessBoard(
                chessBoardController: _chessBoardController,
                size: size.width > size.height
                    ? size.height * 0.9
                    : size.width * 0.9,
                onMove: (move) {},
                onDraw: () {},
                onCheckMate: (color) {},
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Zurücksetzen"),
                    onPressed: () => _chessBoardController.loadPGN(widget.pgn),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
