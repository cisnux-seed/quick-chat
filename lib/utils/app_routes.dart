import 'package:flutter/widgets.dart';
import 'package:quick_chat/presentation/views/mobile_chat_view.dart';
import 'package:quick_chat/presentation/views/mobile_create_profile_view.dart';
import 'package:quick_chat/presentation/views/mobile_forgot_password_view.dart';
import 'package:quick_chat/presentation/views/mobile_home_view.dart';
import 'package:quick_chat/presentation/views/mobile_image_view.dart';
import 'package:quick_chat/presentation/views/mobile_login_view.dart';
import 'package:quick_chat/presentation/views/mobile_register_view.dart';
import 'package:get/route_manager.dart';
import 'package:quick_chat/presentation/views/mobile_search_view.dart';
import 'package:quick_chat/presentation/views/splash_view.dart';

const kMobileHomeView = '/home-view';
const kMobileLoginView = '/login-view';
const kMobileRegisterView = '/register-view';
const kMobileForgotPasswordView = '/forgot-password-view';
const kMobileCreateProfileView = '/create-profile-view';
const kMobileChatView = '/chat-view';
const kMobileSearchView = '/search-view';
const kMobileImageView = '/mobile-image-view';
const kSplashView = '/splash-view';
String? initialRoute;

var appViews = [
  GetPage(
    name: kMobileLoginView,
    page: () => const MobileLoginView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kMobileRegisterView,
    page: () => const MobileRegisterView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kMobileCreateProfileView,
    page: () => const MobileCreateProfileView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kMobileHomeView,
    page: () => const MobileHomeView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kMobileForgotPasswordView,
    page: () => const MobileForgotPasswordView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kMobileChatView,
    page: () => const MobileChatView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kMobileSearchView,
    page: () => const MobileSearchView(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: kSplashView,
    page: () => const SplashView(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: kMobileImageView,
    page: () => MobileImageView(),
    transition: Transition.fadeIn,
  ),
];

final RouteObserver<ModalRoute> kRouteObserver = RouteObserver<ModalRoute>();
