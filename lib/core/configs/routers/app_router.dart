import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/services/location/bloc/location_bloc.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/bloc/forget_password_bloc.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/forget_password_page.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/reset_password_page.dart';
import 'package:revive_flutter_project/features/authentication/login/bloc/login_bloc.dart';
import 'package:revive_flutter_project/features/authentication/login/login_page.dart';
import 'package:revive_flutter_project/features/authentication/register/bloc/register_bloc.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_otp_page.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_page.dart';
import 'package:revive_flutter_project/features/home/bloc/branch_bloc/branch_bloc.dart';
import 'package:revive_flutter_project/features/home/bloc/home_bloc/home_bloc.dart';
import 'package:revive_flutter_project/features/home/presentation/branches_page.dart';
import 'package:revive_flutter_project/features/home/presentation/home_page.dart';
import 'package:revive_flutter_project/features/splash/splash_page.dart';

final GoRouter routers = GoRouter(
  routes: [
    GoRoute(
      name: 'splash-page',
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: 'home-page',
      path: '/home',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                HomeBloc()..add(const HomeEvent.loadAllHomeData()),
          ),
          BlocProvider(
            create: (context) => LocationBloc()..add(const LocationEvent.requestLocationPermission()),
          ),
        ],
        child: const HomePage(),
      ),
      routes: [
        GoRoute(
            name: 'branch-list',
            path: '/branch-list',
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    BranchBloc()..add(const BranchEvent.getBranches()),
                child: const BranchesPage(),
              );
            }),
      ],
    ),
    GoRoute(
      name: 'login-page',
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginBloc(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
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
      path: '/forget-password',
      builder: (context, state) => BlocProvider(
        create: (context) => ForgetPasswordBloc(),
        child: const ForgetPasswordPage(),
      ),
      routes: [
        GoRoute(
          name: 'reset-password',
          path: '/reset-password',
          builder: (context, state) {
            final String? email = state.uri.queryParameters['email'];
            return BlocProvider(
              create: (context) => ForgetPasswordBloc(),
              child: ResetPasswordPage(email: email ?? ""),
            );
          },
        ),
      ],
    ),
  ],
);
