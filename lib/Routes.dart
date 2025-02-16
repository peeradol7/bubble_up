import 'package:go_router/go_router.dart';
import 'package:thammasat/View/accounts_page.dart';
import 'package:thammasat/View/home_page.dart';

class AppRoutes {
  static final String homePage = '/home-page';
  static final String accoountPage = '/accounts-page';

  final route = GoRouter(
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
  );
}
