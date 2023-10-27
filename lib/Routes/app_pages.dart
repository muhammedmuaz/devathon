import 'package:devathon/views/Auth/loginScreen.dart';
import 'package:devathon/views/Auth/signupScreen.dart';
import 'package:get/get.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static var initial = _Paths.signup;
  static final routes = [
    // GetPage(
    //   name: _Paths.splash,
    //   page: () => const SplashScreen(),
    // ),
    GetPage(
      name: _Paths.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: _Paths.signup,
      page: () => SignUpPage(),
    ),
  ];
}
