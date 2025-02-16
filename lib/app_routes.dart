import 'package:go_router/go_router.dart';
import 'package:thammasat/View/email_sign_up.dart';
import 'package:thammasat/View/home_page.dart';
import 'package:thammasat/View/login_page.dart';

class AppRoutes {
  static const String homePage = '/home-page';
  static const String loginPage = '/login-page';
  static const String emailSignUp = '/email-sign-up';
  static const String accoountPage = '/accounts-page';

  final route = GoRouter(
    initialLocation: homePage,
    routes: [
      GoRoute(
        path: homePage,
        name: homePage,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: loginPage,
        name: loginPage,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: emailSignUp,
        name: emailSignUp,
        builder: (context, state) => const EmailSignUp(),
      ),
    ],
    redirect: (context, state) {
      print('---path => ${state.uri.toString()}');
      return null;
    },
  );
}
