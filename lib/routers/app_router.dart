import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/forget_password.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/reset_password.dart';
import 'package:revive_flutter_project/features/authentication/login/login_page.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_otp_page.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_page.dart';

final GoRouter routers = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/confirm-otp-register',
          builder: (context, state) => const RegisterOTPPage(),
        ),
        GoRoute(
          path: '/forget-password',
          builder: (context, state) => const ForgetPasswordPage(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const ResetPasswordPage(),
        ),
      ],
    ),
  ],
);
