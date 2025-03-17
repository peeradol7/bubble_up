import 'package:go_router/go_router.dart';
import 'package:thammasat/View/email_sign_up/email_sign_up.dart';
import 'package:thammasat/View/email_sign_up/input_password_page.dart';
import 'package:thammasat/View/home_page/create_order_page/create_order_page.dart';
import 'package:thammasat/View/home_page/home_page.dart';
import 'package:thammasat/View/home_page/profile_page/edit_address_page.dart';
import 'package:thammasat/View/home_page/profile_page/setting_page.dart';
import 'package:thammasat/View/home_page/select_service_widget/service_page/display_type_laundry_page.dart';
import 'package:thammasat/View/landing_page/landing_page.dart';
import 'package:thammasat/View/login_page/login_page.dart';
import 'package:thammasat/View/rider_page/order/my_order_page.dart';
import 'package:thammasat/View/rider_page/order_detail_page.dart';
import 'package:thammasat/View/rider_page/order_list_page.dart';

import 'View/error_page.dart';
import 'View/home_page/profile_page/edit_person_data.dart';
import 'View/rider_page/process_page/process_order_page.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginPage = '/login-page';
  static const String emailSignUp = '/email-sign-up';
  static const String accoountPage = '/accounts-page';
  static const String homePage = '/home-page';
  static const String inputPassword = '/input-password';
  static const String editAddressPage = '/edit-address-data';
  static const String editPersonDataPage = '/edit-persion-data';
  static const String orderListPage = '/rider-home-page';
  static const String createOrderPage = '/create-order';
  static const String settingPage = '/setting';
  static const String orderDetail = '/order-detail';
  static const String myOrderPage = '/my-order';
  static const String processOrderPage = '/process-order-page';
  static const String displayTypeLaundryPage = '/displayTypeLaundryPage';

  final route = GoRouter(
    initialLocation: landingPage,
    routes: [
      GoRoute(
        path: landingPage,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: homePage,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: emailSignUp,
        builder: (context, state) => EmailSignUp(),
      ),
      GoRoute(
        path: inputPassword,
        builder: (context, state) => InputPasswordPage(),
      ),
      GoRoute(
        path: loginPage,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: editAddressPage,
        builder: (context, state) => EditAddressPage(),
      ),
      GoRoute(
        path: editPersonDataPage,
        builder: (context, state) => EditPersonData(),
      ),
      GoRoute(
        path: settingPage,
        builder: (context, state) => SettingPage(),
      ),
      GoRoute(
        path: '$createOrderPage/:laundryId',
        builder: (context, state) {
          final laundryId = state.pathParameters['laundryId'] ?? '';
          return CreateOrderPage(laundryId: laundryId);
        },
      ),
      GoRoute(
        path: orderListPage,
        builder: (context, state) => OrderListPage(),
      ),
      GoRoute(
        path: myOrderPage,
        builder: (context, state) => MyOrderPage(),
      ),
      GoRoute(
        path: '$displayTypeLaundryPage/:type',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? '';
          return DisplayTypeLaundryPage(
            type: type,
          );
        },
      ),
      GoRoute(
        path: '$orderDetail/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return OrderDetailPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: '$processOrderPage/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return ProcessOrderPage(orderId: orderId);
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}
