// settingsPremium.dart
import "../../imports.dart";

class SettingsPremium extends StatefulWidget {
  String username;
  String emailAdress;
  SettingsPremium({@required this.username, @required this.emailAdress});

  @override
  _SettingsPremiumState createState() => _SettingsPremiumState();
}

class _SettingsPremiumState extends State<SettingsPremium> {
  AuthenticationBloc _authenticationBloc;
  GamesBloc _gamesBloc;
  // only necessary during development
  // the value of the premium switch
  bool switchValue = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    this._gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  void switchValueChanged(bool updatedSwitchValue) async {
    print("hi" + this._authenticationBloc.runtimeType.toString());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isUserPremium", updatedSwitchValue);
    this._authenticationBloc.isUserPremiumSink.add(updatedSwitchValue);
    setState(() {
      this.switchValue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
        textTheme: theme.appBarTheme.textTheme,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          children: <Widget>[
            Container(
              height: size.height * 0.35,
              child: Column(
                children: <Widget>[
                  Icon(Icons.account_circle, size: size.height * 0.2),
                  Text(
                    widget.username ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.emailAdress ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Einstellungen"),
            ),
            ListTile(
              title: Text("Premium"),
              trailing: Switch(
                value: true,
                onChanged: (switchValue) => switchValueChanged(switchValue),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ListTile(
                title: Text("Ausloggen"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  Navigator.pop(context);
                  _gamesBloc.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
