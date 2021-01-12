// // main.dart
// import "dart:io";
// import "imports.dart";
// import "package:in_app_purchase/in_app_purchase.dart";

// void main() {
//   InAppPurchaseConnection.enablePendingPurchases();
//   runApp(JustChess());
// }

// // values for in app purchases
// const bool kAutoConsume = true;
// const String _kConsumableId = "consumable";
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   "upgrade",
//   "subscription",
// ];

// class JustChess extends StatefulWidget {
//   @override
//   _JustChessState createState() => _JustChessState();
// }

// class _JustChessState extends State<JustChess> {
//   // fields for in app purchases
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String _queryProductError;

//   @override
//   void initState() {
//     Stream purchaseUpdated =
//         InAppPurchaseConnection.instance.purchaseUpdatedStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       print(error.toString());
//       // handle error here
//     });
//     initStoreInfo();
//     super.initState();
//   }

//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _connection.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _notFoundIds = [];
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//     ProductDetailsResponse productDetailResponse =
//         await _connection.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final QueryPurchaseDetailsResponse purchaseResponse =
//         await _connection.queryPastPurchases();

//     if (purchaseResponse.error != null) {
//       // handle query past purchase error..
//     }
//     final List<PurchaseDetails> verifiedPurchases = [];

//     for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//       if (await _verifyPurchase(purchase)) {
//         verifiedPurchases.add(purchase);
//       }
//     }

//     List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = verifiedPurchases;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // class with all the methods needed for authentication
//     final AuthenticationService _authenticationService =
//         AuthenticationService();
//     // class with all the methods needed for reading and writing from and to CloudFirestore
//     final CloudFirestoreDatabaseApi _cloudFirestoreDatabase =
//         CloudFirestoreDatabase();

//     // has to be local variable because its values are being used in the StreamBuilder below
//     final AuthenticationBloc _authenticationBloc =
//         AuthenticationBloc(authenticationService: _authenticationService);

//     // controls the sign in status of the current user
//     return AuthenticationBlocProvider(
//       authenticationBloc: _authenticationBloc,
//       // checks whether the user is premium or not
//       child: StreamBuilder(
//           stream: _authenticationBloc.isUserPremiumStream,
//           initialData: null,
//           builder: (BuildContext context, AsyncSnapshot userStatusSnapshot) {
//             if (userStatusSnapshot.connectionState == ConnectionState.waiting) {
//               return MaterialApp(
//                 home: Scaffold(
//                   body: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               );
//             } else if (userStatusSnapshot.hasData &&
//                 userStatussnapshot.data() == true) {
//               // controls the loading and saving of the user's games
//               return GamesBlocProvider(
//                 gamesBloc: GamesBloc(
//                   cloudFirestoreDatabase: _cloudFirestoreDatabase,
//                   authenticationService: _authenticationService,
//                 ),
//                 // controls the loading, adding and deleting of the user's friends
//                 child: FriendsBlocProvider(
//                   friendsBloc: FriendsBloc(
//                     authenticationService: _authenticationService,
//                     cloudFirestoreDatabase: _cloudFirestoreDatabase,
//                   ),
//                   // the app for premium user
//                   child: LocalGamesBlocProvider(
//                     localGamesBloc: LocalGamesBloc(),
//                     child: MaterialApp(
//                       debugShowCheckedModeBanner: true,
//                       theme: theme,
//                       // TODO: enable darkTheme when darkmode is implemented
//                       // darkTheme: darkTheme,
//                       home: StreamBuilder(
//                           initialData: null,
//                           // based on the user's authentication status either Home() or SignUp() is being built
//                           stream: _authenticationBloc.user,
//                           builder: (BuildContext context,
//                               AsyncSnapshot userAuthenticationSnapshot) {
//                             // _authenticationBloc.startListeners();
//                             // loading icon while checking the user's authentication status
//                             if (userAuthenticationSnapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Container(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             // is executed if the user is authenticated
//                             else if (userAuthenticationSnapshot.hasData) {
//                               return HomePremium();
//                             }
//                             // is executed if the user isn't authenticated
//                             else {
//                               return SignUp();
//                             }
//                           }),
//                     ),
//                   ),
//                 ),
//               );
//             } else {
//               // the app for non premium user
//               return LocalGamesBlocProvider(
//                 localGamesBloc: LocalGamesBloc(),
//                 child: MaterialApp(
//                   debugShowCheckedModeBanner: true,
//                   theme: theme,
//                   darkTheme: darkTheme,
//                   home: Home(),
//                 ),
//               );
//             }
//           }),
//     );
//   }
// }
