import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/forget_password.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/reset_password.dart';
import 'package:revive_flutter_project/features/authentication/login/bloc/login_bloc.dart';
import 'package:revive_flutter_project/features/authentication/login/login_page.dart';
import 'package:revive_flutter_project/features/authentication/register/bloc/register_bloc.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_otp_page.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_page.dart';

final GoRouter routers = GoRouter(
  routes: [
    GoRoute(
      name: 'login',
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginBloc(),
        child: const LoginPage(),
      ),
      routes: [
        GoRoute(
          name: 'login-page',
          path: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: const RegisterPage(),
          ),
          routes: [
            GoRoute(
              name: 'confirm-otp-register',
              path: 'confirm-otp-register',
              builder: (context, state) {
                final String? email = state.uri.queryParameters['email'];
                return BlocProvider(
                  create: (context) => RegisterBloc(),
                  child: RegisterOTPPage(email: email ?? ""),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: 'forget-password',
          path: 'forget-password',
          builder: (context, state) => const ForgetPasswordPage(),
        ),
        GoRoute(
          name: 'reset-password',
          path: 'reset-password',
          builder: (context, state) => const ResetPasswordPage(),
        ),
      ],
    ),
  ],
);
