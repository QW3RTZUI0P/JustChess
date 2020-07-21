// labeling.dart
import "../imports.dart";

class VerticalNumbersWhite extends StatelessWidget {
  final double height;

  const VerticalNumbersWhite({@required this.height});

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

class VerticalNumbersBlack extends StatelessWidget {
  final double height;

  const VerticalNumbersBlack({@required this.height});

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

class HorizontalLettersWhite extends StatelessWidget {
  final double width;

  const HorizontalLettersWhite({@required this.width});

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

class HorizontalLettersBlack extends StatelessWidget {
  final double width;

  const HorizontalLettersBlack({@required this.width});

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
