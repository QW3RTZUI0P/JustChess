// beschriftung.dart
import "../imports.dart";

class VertikaleZahlen extends StatelessWidget {
  final double height;

  VertikaleZahlen({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("8"),
          Text("7"),
          Text("6"),
          Text("5"),
          Text("4"),
          Text("3"),
          Text("2"),
          Text("1"),
        ],
      ),
    );
  }
}

class HorizontaleBuchstaben extends StatelessWidget {
  final double width;

  HorizontaleBuchstaben({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(child: Text("a")),
          Text("b"),
          Text("c"),
          Text("d"),
          Text("e"),
          Text("f"),
          Text("g"),
          Text("h"),
        ],
      ),
    );
  }
}
