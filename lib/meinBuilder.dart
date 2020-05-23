// meinBuilder.dart
import "./imports.dart";

class MeinBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PartienProvider partienProvider = Provider.of<PartienProvider>(context);
    return Home(
      partien: partienProvider.datenbank.partien ?? [],
      partieGeloescht: partienProvider.partieGeloescht,
    );
  }
}
