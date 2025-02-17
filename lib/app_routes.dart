import 'package:go_router/go_router.dart';
import 'package:thammasat/View/home_page.dart';
import 'package:thammasat/View/login_dialog.dart';
import 'package:thammasat/View/select_service_page.dart';

class AppRoutes {
  static const String homePage = '/home-page';
  static const String loginPage = '/login-page';
  static const String accoountPage = '/accounts-page';
  static const String selectServicePage = '/select-service';

  final route = GoRouter(
    initialLocation: selectServicePage,
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
        path: selectServicePage,
        name: selectServicePage,
        builder: (context, state) => const SelectServicePage(),
      ),
    ],
    redirect: (context, state) {
      print('---path => ${state.uri.toString()}');
      return null;
    },
  );
}
