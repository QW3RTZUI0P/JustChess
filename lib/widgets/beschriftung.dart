// beschriftung.dart
import "../imports.dart";

class VertikaleZahlenWeiss extends StatelessWidget {
  final double height;

  const VertikaleZahlenWeiss({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text(
            "8",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "7",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "6",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "5",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "4",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "3",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "2",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "1",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class VertikaleZahlenSchwarz extends StatelessWidget {
  final double height;

  const VertikaleZahlenSchwarz({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text(
            "1",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "2",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "3",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "4",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "5",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "6",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "7",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "8",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontaleBuchstabenWeiss extends StatelessWidget {
  final double width;

  const HorizontaleBuchstabenWeiss({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width + MediaQuery.of(context).textScaleFactor + 5,
      child: Row(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(" "),
              const SizedBox(width: 6.0),
            ],
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text(
                  "a",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "b",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "c",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "d",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "e",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "f",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "g",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "h",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontaleBuchstabenSchwarz extends StatelessWidget {
  final double width;

  const HorizontaleBuchstabenSchwarz({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width + MediaQuery.of(context).textScaleFactor + 5,
      child: Row(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(" "),
              const SizedBox(width: 6.0),
            ],
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text(
                  "h",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "g",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "f",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "e",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "d",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "c",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "b",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "a",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
