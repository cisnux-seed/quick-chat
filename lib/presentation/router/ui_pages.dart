import 'package:quick_chat/presentation/router/app_state.dart';

const String splashPath = '/splash';
const String loginPath = '/login';
const String createAccountPath = '/createAccount';
const String listItemsPath = '/listItems';
const String detailsPath = '/details';
const String cartPath = '/cart';
const String checkoutPath = '/checkout';
const String settingsPath = '/settings';

enum Pages {
  splash,
  login,
  createAccount,
  list,
  details,
  cart,
  checkout,
  settings
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction? currentPageAction;

  PageConfiguration({
    required this.key,
    required this.path,
    required this.uiPage,
    this.currentPageAction,
  });
}

PageConfiguration splashPageConfig = PageConfiguration(
  key: 'Splash',
  path: splashPath,
  uiPage: Pages.splash,
);

PageConfiguration loginPageConfig = PageConfiguration(
  key: 'Login',
  path: loginPath,
  uiPage: Pages.login,
);

PageConfiguration createAccountPageConfig = PageConfiguration(
  key: 'CreateAccount',
  path: createAccountPath,
  uiPage: Pages.createAccount,
);

PageConfiguration listItemsPageConfig = PageConfiguration(
  key: 'ListItems',
  path: listItemsPath,
  uiPage: Pages.list,
);

PageConfiguration detailsPageConfig = PageConfiguration(
  key: 'Details',
  path: detailsPath,
  uiPage: Pages.details,
);

PageConfiguration cartPageConfig = PageConfiguration(
  key: 'Cart',
  path: cartPath,
  uiPage: Pages.cart,
);

PageConfiguration checkoutPageConfig = PageConfiguration(
  key: 'Checkout',
  path: checkoutPath,
  uiPage: Pages.checkout,
);

PageConfiguration settingsPageConfig = PageConfiguration(
  key: 'Settings',
  path: settingsPath,
  uiPage: Pages.settings,
);
