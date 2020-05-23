// main.dart
import "imports.dart";

void main() => runApp(JustChess());

class JustChess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PartienProvider(),
      child: MaterialApp(
        title: "JustChess",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: MeinBuilder(),
      ),
    );
  }
}
