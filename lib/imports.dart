// imports.dart
// 1
export "dart:io";
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
export "./main.dart";
// pages

// normal:
export "./pages/normal/game.dart";
export "./pages/normal/settings.dart";
export "./pages/normal/createGame.dart";
export "./pages/normal/about.dart";
// home:
export "./pages/normal/home/home.dart";
export "./pages/normal/home/menu.dart";
export "./pages/normal/home/createGameButton.dart";

//
// premium:
export "./pages/premium/signUp.dart";
export "./pages/premium/signIn.dart";
export "./pages/premium/settingsPremium.dart";
export 'pages/premium/createOnlineGame.dart';
export "./pages/premium/gameTypeSelection.dart";
export "./pages/premium/invitations.dart";
// homePremium:
export "./pages/premium/homePremium/homePremium.dart";
export "./pages/premium/homePremium/menuPremium.dart";
export "./pages/premium/homePremium/createGameButtonPremium.dart";
// gamePremium:
export "./pages/premium/gamePremium/gamePremium.dart";
export "./pages/premium/gamePremium/chessBoardWidgetPremium.dart";
export "./pages/premium/gamePremium/tryOutChessBoardWidget.dart";
export "./pages/premium/gamePremium/gameStatusDialogs.dart";
export "./pages/premium/gamePremium/gamePremiumOptionsButton.dart";
// friends:
export "./pages/premium/friends/friends.dart";
export "./pages/premium/friends/findNewFriend.dart";

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
export "./blocs/localGamesBloc.dart";
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
