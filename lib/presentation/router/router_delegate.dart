/*
 * Copyright (c) 2021 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/presentation/router/app_state.dart';
import '../app_state.dart';
import '../ui/details.dart';
import '../ui/cart.dart';
import '../ui/checkout.dart';
import '../ui/create_account.dart';
import '../ui/list_items.dart';
import '../ui/login.dart';
import '../ui/settings.dart';
import '../ui/splash.dart';
import 'back_dispatcher.dart';
import 'ui_pages.dart';

class ShoppingRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];
  ShoppingBackButtonDispatcher? backButtonDispatcher;

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  ShoppingRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    // if (page != null) {
    _pages.remove(page);
    // }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
      child: child,
      key: ValueKey(pageConfig.key),
      name: pageConfig.path,
      arguments: pageConfig,
    );
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration pageConfig) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;
    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.splash:
          _addPageData(const Splash(), splashPageConfig);
          break;
        case Pages.login:
          _addPageData(const Login(), loginPageConfig);
          break;
        case Pages.createAccount:
          _addPageData(const CreateAccount(), createAccountPageConfig);
          break;
        case Pages.list:
          _addPageData(const ListItems(), listItemsPageConfig);
          break;
        case Pages.cart:
          _addPageData(const Cart(), cartPageConfig);
          break;
        case Pages.checkout:
          _addPageData(const Checkout(), checkoutPageConfig);
          break;
        case Pages.settings:
          _addPageData(const Settings(), settingsPageConfig);
          break;
        case Pages.details:
          if (pageConfig.currentPageAction != null) {
            _addPageData(
              pageConfig.currentPageAction?.widget ?? const SizedBox(),
              pageConfig,
            );
          }
          break;
        default:
          break;
      }
    }
  }

  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    for (final route in routes) {
      addPage(route);
    }
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page?.uiPage) {
      case Pages.splash:
        splashPageConfig.currentPageAction = action;
        break;
      case Pages.login:
        loginPageConfig.currentPageAction = action;
        break;
      case Pages.createAccount:
        createAccountPageConfig.currentPageAction = action;
        break;
      case Pages.list:
        listItemsPageConfig.currentPageAction = action;
        break;
      case Pages.cart:
        cartPageConfig.currentPageAction = action;
        break;
      case Pages.checkout:
        checkoutPageConfig.currentPageAction = action;
        break;
      case Pages.settings:
        settingsPageConfig.currentPageAction = action;
        break;
      case Pages.details:
        detailsPageConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {
    if (!appState.splashFinished) {
      replaceAll(splashPageConfig);
    } else {
      switch (appState.currentAction.state) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(appState.currentAction);
          if (appState.currentAction.page != null) {
            addPage(appState.currentAction.page!);
          }
          break;
        case PageState.pop:
          pop();
          break;
        case PageState.replace:
          _setPageAction(appState.currentAction);
          if (appState.currentAction.page != null) {
            replace(appState.currentAction.page!);
          }
          break;
        case PageState.replaceAll:
          _setPageAction(appState.currentAction);
          if (appState.currentAction.page != null) {
            replaceAll(appState.currentAction.page!);
          }
          break;
        case PageState.addWidget:
          _setPageAction(appState.currentAction);
          if (appState.currentAction.page != null) {
            pushWidget(
              appState.currentAction.widget ?? const SizedBox(),
              appState.currentAction.page!,
            );
          }
          break;
        case PageState.addAll:
          if (appState.currentAction.pages != null) {
            addAll(appState.currentAction.pages!);
          }
          break;
      }
    }
    appState.resetCurrentAction();
    return List.of(_pages);
  }

  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(splashPageConfig);
      return;
    }

    // Handle navapp://deeplinks/details/#
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'details') {
        pushWidget(Details(int.parse(uri.pathSegments[1])), detailsPageConfig);
      }
    } else if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      switch (path) {
        case 'splash':
          replaceAll(splashPageConfig);
          break;
        case 'login':
          replaceAll(loginPageConfig);
          break;
        case 'createAccount':
          setPath([
            _createPage(const Login(), loginPageConfig),
            _createPage(const CreateAccount(), createAccountPageConfig)
          ]);
          break;
        case 'listItems':
          replaceAll(listItemsPageConfig);
          break;
        case 'cart':
          setPath([
            _createPage(const ListItems(), listItemsPageConfig),
            _createPage(const Cart(), cartPageConfig)
          ]);
          break;
        case 'checkout':
          setPath([
            _createPage(const ListItems(), listItemsPageConfig),
            _createPage(const Checkout(), checkoutPageConfig)
          ]);
          break;
        case 'settings':
          setPath([
            _createPage(const ListItems(), listItemsPageConfig),
            _createPage(const Settings(), settingsPageConfig)
          ]);
          break;
      }
    }
  }
}
