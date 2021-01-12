// authenticationBloc.dart
import "../imports.dart";
import "package:shared_preferences/shared_preferences.dart";

// class that handles authentication and checks whether the user is premium or not
class AuthenticationBloc {
  final AuthenticationApi authenticationService;

  // Stream, der den Status der Authentisierung überwacht
  StreamController<String> _authenticationController =
      StreamController<String>();
  // wenn sich der Status ändert, wird diesem Sink etwas hinzugefügt
  Sink<String> get addUser => _authenticationController.sink;
  // wenn dem Sink addUser etwas hinzugefügt wird, wird dieser Stream benachrichtigt
  Stream<String> get user => _authenticationController.stream;
  // checks whether the user has logged out
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc({this.authenticationService}) {
    startListeners();
    // _initialize();
    // getUserStatus();
  }

  // checks all the time the user's authentication status
  void startListeners() async {
    await authenticationService.getFirebaseAuth();
    // is executed when the user logs in or logs out
    authenticationService.getFirebaseAuth().authStateChanges().listen((User user) async {
      final String uid = user != null ? user.uid : null;
      addUser.add(uid);
    });
    // is executed when the user presses the logout button
    _logoutController.stream.listen((logoutBool) {
      if (logoutBool == true) {
        authenticationService.signOut();
      }
    });
    await _hasUserNewEmail();
  }

  // closes the three StreamControllers
  void dispose() {
    _authenticationController.close();
    _logoutController.close();
    // _subscription.cancel();
  }

  Future<void> _hasUserNewEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool hasUserNewEmailVariable = sharedPreferences.getBool("hasUserNewEmail");
    if (hasUserNewEmailVariable != true) {
      sharedPreferences.setBool("hasUserNewEmail", true);
      authenticationService.signOut();
    }
  }
}

// InheritedWidget that provides the authenticationBloc
class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;
  const AuthenticationBlocProvider(
      {Key key, Widget child, this.authenticationBloc})
      : super(key: key, child: child);
  static AuthenticationBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>();
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) {
    // returns true if the two InheritedWidgets differ from each other

    return authenticationBloc != oldWidget.authenticationBloc;
  }
}

// in app purchase section:
// values for in app purchases
// product ID
// final String productID = "justchess_premium";

// values for in app purchases
/// IAP plugin interface
// InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

// /// is the API available on the device
// bool _available = true;

// /// product for sale (justchess_premium)
// List<ProductDetails> _product = [];

// /// past purchase (whether the user has bought the justchess_premium subscription)
// List<PurchaseDetails> _pastPurchase = [];

// /// updates to _pastPurchase
// StreamSubscription _subscription;

// functions for in app purchases
/// Initialize data
// void _initialize() async {
//   // Check availability of in app purchases
//   _available = await _iap.isAvailable();

//   if (_available) {
//     await _getProduct();
//     await _getPastPurchase();

//     // Verify and deliver a purchase with my own business logic
//     _verifyPurchase();
//   } else {
//     // if the in app purchase service isn't available, the user will be treated as non-premium
//     isUserPremiumSink.add(false);
//   }

//   // listen to new purchases
//   _subscription =
//       _iap.purchaseUpdatedStream.listen((List<PurchaseDetails> data) {
//     print("NEW PURCHASE");
//     _pastPurchase.addAll(data);
//     _verifyPurchase();
//   });
// }

// /// Get all products available for sale
// Future<void> _getProduct() async {
//   Set<String> ids = Set.from([productID]);
//   ProductDetailsResponse response = await _iap.queryProductDetails(ids);

//   print("Product Details");
//   print(response.productDetails.toString());

//   _product = response.productDetails;
// }

// /// Gets past purchases
// Future<void> _getPastPurchase() async {
//   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

//   for (PurchaseDetails purchase in response.pastPurchases) {
//     final pending = Platform.isIOS
//         // actually purchaseDetails. ... instead of purchase. ...
//         ? purchase.pendingCompletePurchase
//         : !purchase.billingClientPurchase.isAcknowledged;
//     if (pending) {
//       InAppPurchaseConnection.instance.completePurchase(purchase);
//     }
//   }

//   _pastPurchase = response.pastPurchases;
// }

// /// Returns purchases of specific product ID
// PurchaseDetails _hasPurchased(String productID) {
//   return _pastPurchase.firstWhere(
//       (purchase) => purchase.productID == productID,
//       orElse: () => null);
// }

// /// My own business logic to setup a consumable
// void _verifyPurchase() {
//   PurchaseDetails purchase = _hasPurchased(productID);

//   // TODO: serverside verification & record consumable in the database
//   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//     // adds that the user is premium to the right stream
//     isUserPremiumSink.add(true);
//   } else {
//     isUserPremiumSink.add(false);
//   }
// }

// /// buy a product
// void buyProduct(ProductDetails prod) {
//   final PurchaseParam purchaseParam = PurchaseParam(
//     productDetails: prod,
//     sandboxTesting: true,
//     applicationUserName: null,
//   );
//   // only for non-consumables
//   _iap.buyNonConsumable(purchaseParam: purchaseParam);
//   // only for consumables
//   // _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
// }
