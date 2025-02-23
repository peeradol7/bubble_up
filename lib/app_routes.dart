import 'package:go_router/go_router.dart';
import 'package:thammasat/View/email_sign_up/email_sign_up.dart';
import 'package:thammasat/View/email_sign_up/input_password_page.dart';
import 'package:thammasat/View/home_page/create_order_page/create_order_page.dart';
import 'package:thammasat/View/home_page/home_page.dart';
import 'package:thammasat/View/home_page/profile_page/edit_address_page.dart';
import 'package:thammasat/View/home_page/profile_page/setting_page.dart';
import 'package:thammasat/View/landing_page/landing_page.dart';
import 'package:thammasat/View/login_page/login_page.dart';
import 'package:thammasat/View/rider_page/rider_home_page.dart';

import 'View/home_page/profile_page/edit_person_data.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginPage = '/login-page';
  static const String emailSignUp = '/email-sign-up';
  static const String accoountPage = '/accounts-page';
  static const String homePage = '/home-page';
  static const String inputPassword = '/input-password';
  static const String editAddressPage = '/edit-address-data';
  static const String editPersonDataPage = '/edit-persion-data';
  static const String riderHomePage = '/rider-home-page';
  static const String createOrderPage = '/create-order';
  static const String settingPage = '/setting';

  final route = GoRouter(
    initialLocation: landingPage,
    routes: [
      GoRoute(
          path: landingPage,
          name: landingPage,
          builder: (context, state) {
            return const LandingPage();
          }),
      GoRoute(
          path: homePage,
          name: homePage,
          builder: (context, state) {
            return const HomePage();
          }),
      GoRoute(
          path: emailSignUp,
          name: emailSignUp,
          builder: (context, state) {
            return EmailSignUp();
          }),
      GoRoute(
          path: inputPassword,
          name: inputPassword,
          builder: (context, state) {
            return InputPasswordPage();
          }),
      GoRoute(
          path: loginPage,
          name: loginPage,
          builder: (context, state) {
            return const LoginPage();
          }),
      GoRoute(
          path: editAddressPage,
          name: editAddressPage,
          builder: (context, state) {
            return EditAddressPage();
          }),
      GoRoute(
          path: editPersonDataPage,
          name: editPersonDataPage,
          builder: (context, state) {
            return EditPersonData();
          }),
      GoRoute(
          path: settingPage,
          name: settingPage,
          builder: (context, state) {
            return SettingPage();
          }),
      GoRoute(
          path: riderHomePage,
          name: riderHomePage,
          builder: (context, state) {
            return RiderHomePage();
          }),
      GoRoute(
          path: '$createOrderPage/:laundryId',
          name: createOrderPage,
          builder: (context, state) {
            final laundryId = state.pathParameters['laundryId'] ?? '';
            return CreateOrderPage(
              laundryId: laundryId,
            );
          }),
    ],
    redirect: (context, state) {
      print('---path => ${state.uri.toString()}');
      return null;
    },
  );
}
