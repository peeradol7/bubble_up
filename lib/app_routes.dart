import 'package:go_router/go_router.dart';
import 'package:thammasat/View/accounts_page.dart';
import 'package:thammasat/View/home_page.dart';

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
        path: accoountPage,
        name: accoountPage,
        builder: (context, state) => const AccountsPage(),
      ),
    ],
    redirect: (context, state) {
      print('---path => ${state.uri.toString()}');
      return null;
    },
  );
}
