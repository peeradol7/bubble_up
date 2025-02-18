import 'package:go_router/go_router.dart';
import 'package:thammasat/View/email_sign_up/email_sign_up.dart';
import 'package:thammasat/View/email_sign_up/input_password_page.dart';
import 'package:thammasat/View/home_page.dart';
import 'package:thammasat/View/login_page.dart';
import 'package:thammasat/View/select_service_page.dart';

class AppRoutes {
  static const String homePage = '/';
  static const String loginPage = '/login-page';
  static const String emailSignUp = '/email-sign-up';
  static const String accoountPage = '/accounts-page';
  static const String selectServicePage = '/select-service';
  static const String inputPassword = '/input-password';

  final route = GoRouter(
    initialLocation: homePage,
    routes: [
      GoRoute(
          path: homePage,
          name: homePage,
          builder: (context, state) {
            return const HomePage();
          }),
      GoRoute(
          path: selectServicePage,
          name: selectServicePage,
          builder: (context, state) {
            return const SelectServicePage();
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
    ],
    redirect: (context, state) {
      print('---path => ${state.uri.toString()}');
      return null;
    },
  );
}
