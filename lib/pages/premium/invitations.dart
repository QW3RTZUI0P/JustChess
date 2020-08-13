// invitations.dart
import "../../imports.dart";

class Invitations extends StatefulWidget {
  GamesBloc gamesBloc;

  Invitations({this.gamesBloc});

  @override
  _InvitationsState createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations>
    with AfterLayoutMixin<Invitations> {
  @override
  void afterFirstLayout(BuildContext context) {
    widget.gamesBloc.refreshInvitationListStream();
  }

  Future<void> refresh() async {
    await widget.gamesBloc.refreshInvitations();
    return;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    List<InvitationClass> invitationsList =
        List.from(this.widget.gamesBloc.invitationsList);

    var appBar = AppBar(
      title: Text("Einladungen"),
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: invitationsList.isEmpty
            // TODO: find here and in HomePremium something else to scroll
            ? RefreshIndicator(
                onRefresh: () => refresh(),
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: mediaQueryData.size.height -
                          appBar.preferredSize.height -
                          mediaQueryData.padding.top -
                          mediaQueryData.padding.bottom,
                      child: Center(
                        child: Text(
                          "Noch keine Einladungen bekommen",
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => refresh(),
                child: StreamBuilder(
                  stream: widget.gamesBloc.invitationsListStream,
                  initialData: widget.gamesBloc.invitationsList,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children: snapshot.data
                          .map<Widget>(
                            (currentInvitation) => Column(
                              children: [
                                Dismissible(
                                  key: Key(currentInvitation.gameID),
                                  child: ListTile(
                                    title: Text(
                                        "Einladung von ${currentInvitation.fromUsername}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            // TODO: inform the user that his invitation has been dismissed / neglected
                                            // deletes the invitation
                                            widget.gamesBloc
                                                .cloudFirestoreDatabase
                                                .deleteInvitationFromFirestore(
                                                    userID:
                                                        currentInvitation.toID,
                                                    invitation:
                                                        currentInvitation);
                                            // deletes the gameID from the user's (who sent the invitation) document
                                            widget.gamesBloc
                                                .cloudFirestoreDatabase
                                                .deleteGameIDFromFirestore(
                                                    userID: currentInvitation
                                                        .fromID,
                                                    gameID: currentInvitation
                                                        .gameID);
                                            // deletes the game from the games collection in CloudFirestore
                                            widget.gamesBloc
                                                .cloudFirestoreDatabase
                                                .deleteGameFromFirestore(
                                                    gameID: currentInvitation
                                                        .gameID);

                                            // deletes the invitation locally from invitationsList in gamesBloc
                                            widget.gamesBloc.invitationsList
                                                .remove(currentInvitation);
                                            widget.gamesBloc
                                                .refreshInvitationListStream();
                                            // only closes the view is there was only one invitation
                                            if (snapshot.data.length <= 1) {
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            // adds the new game locally
                                            widget.gamesBloc.gameIDSink
                                                .add(currentInvitation.gameID);
                                            // adds the gameID in CloudFirestore
                                            widget.gamesBloc
                                                .cloudFirestoreDatabase
                                                .addGameIDToFirestore(
                                              userID: currentInvitation.toID,
                                              gameID: currentInvitation.gameID,
                                            );
                                            // deletes the invitation from CloudFirestore
                                            widget.gamesBloc
                                                .cloudFirestoreDatabase
                                                .deleteInvitationFromFirestore(
                                                    userID:
                                                        currentInvitation.toID,
                                                    invitation:
                                                        currentInvitation);
                                            setState(() {
                                              // deletes the invitation locally from invitationsList in gamesBloc
                                              widget.gamesBloc.invitationsList
                                                  .remove(currentInvitation);
                                              widget.gamesBloc
                                                  .refreshInvitationListStream();
                                            });

                                            if (snapshot.data.length <= 1) {
                                              Navigator.pop(context);
                                            }
                                            widget.gamesBloc
                                                .refreshOnlineGames();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
