// imports.dart

// TODO: make everything here like this "export "package:JustChess/lib/...""

// 1
export "dart:async";
export "package:flutter/material.dart";
export "package:path_provider/path_provider.dart";
export "package:shared_preferences/shared_preferences.dart";
export "package:url_launcher/url_launcher.dart";
export "package:in_app_purchase/in_app_purchase.dart";
// Firebase
export "package:firebase_core/firebase_core.dart";
export "package:cloud_firestore/cloud_firestore.dart";
export "package:firebase_auth/firebase_auth.dart";
export "package:firebase_dynamic_links/firebase_dynamic_links.dart";
//
//
//
// 2
// export "./main.dart";
// pages
export "./pages/signIn.dart";
export "./pages/signUp.dart";
export "./pages/settings.dart";
export "./pages/invitations.dart";
export "./pages/about.dart";
// home:
export "./pages/home/home.dart";
export "./pages/home/menu.dart";
// game:
export "./pages/game/game.dart";
export "./pages/game/onlineGame.dart";
export "./pages/game/chessBoardWidget.dart";
export "./pages/game/tryOutChessBoardWidget.dart";
export "./pages/game/gameStatusDialogs.dart";
export "./pages/game/gameOptionsButton.dart";
// createGame:
export "./pages/createGame/createGameButton.dart";
export "./pages/createGame/createGame.dart";
export "./pages/createGame/createOnlineGame.dart";
export "./pages/createGame/gameTypeSelection.dart";
// friends:
export "./pages/friends/friends.dart";
export "./pages/friends/findNewFriend.dart";

//
//
// classes
export "./classes/gameClass.dart";
export "./classes/partienProvider.dart";
export "./classes/validators.dart";
export "./classes/invitationClass.dart";
//
//
// services
export "./services/authentication.dart";
export "./services/cloudFirestoreDatabase.dart";
export "./services/localDatabase.dart";
//
//
// blocs
export "./blocs/authenticationBloc.dart";
export "./blocs/gamesBloc.dart";
export "./blocs/loginBloc.dart";
export "./blocs/friendsBloc.dart";
//
//
// widgets:
export "./widgets/theme.dart";
export "./widgets/labeling.dart";
export "./widgets/snackbarMessage.dart";
//
//
// flutter_chess_board:
export "./flutter_chess_board/flutter_chess_board.dart";
//
//
//
// 3
export "package:uuid/uuid.dart";
export "package:after_layout/after_layout.dart";
