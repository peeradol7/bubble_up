import 'package:go_router/go_router.dart';
import 'package:thammasat/View/home_page.dart';
import 'package:thammasat/View/login_dialog.dart';

class AppRoutes {
  static const String homePage = '/home-page';
  static const String loginPage = '/login-page';
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
    ],
    redirect: (context, state) {
      print('---path => ${state.uri.toString()}');
      return null;
    },
  );
}
