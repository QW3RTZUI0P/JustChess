// settingsPremium.dart
import 'package:flutter/services.dart';

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

  // gets called when the isUserPremium Switch changes value (only for debugging purposes)
  void switchValueChanged(bool updatedSwitchValue) async {
    print("hi" + this._authenticationBloc.runtimeType.toString());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isUserPremium", updatedSwitchValue);
    this._authenticationBloc.isUserPremiumSink.add(updatedSwitchValue);
    setState(() {
      this.switchValue = false;
    });
  }

  // gets called when the user wants to reset his password
  void resetPassword(BuildContext currentContext) {
    _authenticationBloc.authenticationService
        .sendResetPasswortEmail()
        .then((_) {
      Scaffold.of(currentContext).showSnackBar(SnackBar(
        content: Text("Passwort zurücksetzen Mail geschickt"),
      ));
    });
  }

  // gets called when the user wants to delete his accout
  void deleteAccount(BuildContext currentContext) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController _passwordController = TextEditingController();
          return Dialog(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Löschen bestätigen",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        "Gib bitte dein Passwort ein, um deinen Account zu löschen"),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Passwort"),
                    ),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "Account löschen",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            // gets the current user's email (so that he doesn't have to type it in for himself)
                            String emailAdress = await _authenticationBloc
                                .authenticationService
                                .currentUserEmail();
                            // gets the users current credentials
                            String userID = await _authenticationBloc
                                .authenticationService
                                .currentUserUid();
                            String username = await _gamesBloc
                                .cloudFirestoreDatabase
                                .getUsernameForUserID(userID: userID);
                            try {
                              // reauthenticates the user and deletes the account
                              // actions like deleting the account need a recent sign in process
                              await _authenticationBloc.authenticationService
                                  .deleteAccount(
                                email: emailAdress,
                                password: _passwordController.text,
                              );

                              // deletes the username and the userID from the usernames document in the users collection
                              _gamesBloc.cloudFirestoreDatabase
                                  .deleteUserFromFirestore(
                                      userID: userID, username: username);
                              // clears the current data
                              _gamesBloc.signOut();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Scaffold.of(currentContext).showSnackBar(
                                SnackBar(
                                  content: Text("Account erfolgreich gelöscht"),
                                ),
                              );
                            } on PlatformException catch (platformException) {
                              Navigator.pop(context);
                              Failure(
                                      context: currentContext,
                                      errorMessage: platformException.code)
                                  .showErrorSnackBar();
                            } catch (error) {
                              print(error.runtimeType);
                              Navigator.pop(context);
                              // shows SnackBar with the thrown error
                              Scaffold.of(currentContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("Abbrechen"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    _authenticationBloc.authenticationService.deleteAccount();
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
        // has to be Builder (to get the context "under" the Scaffold Widget to show SnackBar)
        child: Builder(
          builder: (BuildContext currentContext) => ListView(
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

                  // onChanged: (switchValue) => switchValueChanged(switchValue),
                ),
              ),
              // TODO: lay this out a bit better (with titles for different sections etc.)
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
              ListTile(
                title: Text("Passwort zurücksetzen"),
                onTap: () => resetPassword(currentContext),
              ),

              ListTile(
                title: Text("Account löschen"),
                onTap: () => deleteAccount(currentContext),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
