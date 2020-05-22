// home.dart
import "../imports.dart";
import "dart:convert";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print(path);
    return File('$path/gespeichertePartien.txt');
  }

  Future<dynamic> readContent({bool asJson = true}) async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      if (asJson == true) {
        var jsonObject = jsonDecode(contents);
        print(jsonObject);
        return jsonObject;
      } else {
        return contents;
      }
    } catch (e) {
      // If there is an error reading, return a default String
      return {};
    }
  }

  Future<List<PartieKlasse>> holePartien() async {
    List<PartieKlasse> partien = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> partienIDs =
        sharedPreferences.getStringList("partienIDs") ?? [];    
    Map fileContents = await readContent(asJson: true);
    print(fileContents.length);
    for (int i = 0; i < fileContents.length; i++) {
      for (int j = 0; j < partienIDs.length; j++) {
        String aktuellePartieID = partienIDs[j];
        partien.add(
          PartieKlasse(
              id: fileContents[aktuellePartieID]["id"],
              name: fileContents[aktuellePartieID]["name"],
              pgn: fileContents[aktuellePartieID]["pgn"]),
        );
        print("hier");
        print(fileContents[aktuellePartieID]["id"]);
      }
    }
    print("fertig");
    return partien;
  }

  @override
  Widget build(BuildContext context) {
    PartienProvider partienProvider = Provider.of<PartienProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("JustChess"),
        actions: <Widget>[
          NeuePartieButton(),
        ],
      ),
      body: FutureBuilder(
          future: holePartien(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? snapshot.data.isEmpty || snapshot.data.length == 0
                    ? Center(
                        child: Text("Noch keine Partien hinzgefügt"),
                      )
                    : ListView(
                        children:
                            partienProvider.partien.map<Widget>((aktuellePartieKlasse) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(aktuellePartieKlasse.name),
                                trailing: Icon(
                                  Icons.arrow_forward,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: false,
                                        builder: (context) {
                                          return Partie(
                                            aktuellePartie:
                                                aktuellePartieKlasse,
                                          );
                                        }),
                                  );
                                },
                              ),
                              Divider(),
                            ],
                          );
                        }).toList(),
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
