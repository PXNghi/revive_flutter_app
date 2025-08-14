import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/services/location/bloc/location_bloc.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_bottom_nav_bar.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/bloc/forget_password_bloc.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/forget_password_page.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/presentations/reset_password_page.dart';
import 'package:revive_flutter_project/features/authentication/login/bloc/login_bloc.dart';
import 'package:revive_flutter_project/features/authentication/login/login_page.dart';
import 'package:revive_flutter_project/features/authentication/register/bloc/register_bloc.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_otp_page.dart';
import 'package:revive_flutter_project/features/authentication/register/presentations/register_page.dart';
import 'package:revive_flutter_project/features/chat/bloc/chat_bloc.dart';
import 'package:revive_flutter_project/features/chat/presentation/chat_list_page.dart';
import 'package:revive_flutter_project/features/chat/presentation/chat_page.dart';
import 'package:revive_flutter_project/features/home/bloc/branch_bloc/branch_bloc.dart';
import 'package:revive_flutter_project/features/home/bloc/home_bloc/home_bloc.dart';
import 'package:revive_flutter_project/features/home/presentation/branches_page.dart';
import 'package:revive_flutter_project/features/home/presentation/home_page.dart';
import 'package:revive_flutter_project/features/order/bloc/add_order/order_bloc.dart';
import 'package:revive_flutter_project/features/order/bloc/main_order/main_order_bloc.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';
import 'package:revive_flutter_project/features/order/presentation/confirmed_order_page.dart';
import 'package:revive_flutter_project/features/order/presentation/create_order_page.dart';
import 'package:revive_flutter_project/features/order/presentation/detailed_order_page.dart';
import 'package:revive_flutter_project/features/order/presentation/order_page.dart';
import 'package:revive_flutter_project/features/order/presentation/search_order_page.dart';
import 'package:revive_flutter_project/features/order/presentation/success_order_page.dart';
import 'package:revive_flutter_project/features/person/bloc/change_password/change_password_bloc.dart';
import 'package:revive_flutter_project/features/person/bloc/user_management/user_management_bloc.dart';
import 'package:revive_flutter_project/features/person/presentation/admin/user_management_page.dart';
import 'package:revive_flutter_project/features/person/presentation/person_page.dart';
import 'package:revive_flutter_project/features/person/presentation/user/change_password_page.dart';
import 'package:revive_flutter_project/features/person/presentation/user/user_profile_page.dart';
import 'package:revive_flutter_project/features/product/bloc/product/product_bloc.dart';
import 'package:revive_flutter_project/features/product/product_page.dart';
import 'package:revive_flutter_project/features/splash/splash_page.dart';
import 'package:revive_flutter_project/features/statistics/bloc/statistics_bloc.dart';
import 'package:revive_flutter_project/features/statistics/statistics_page.dart';

final GoRouter routers = GoRouter(
  routes: [
    GoRoute(
      name: 'splash-page',
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    ShellRoute(
      builder: (context, GoRouterState state, child) {
        final role = SessionData.mine?.role ?? "User";
        final location = GoRouter.of(context)
            .routerDelegate
            .currentConfiguration
            .uri
            .toString();
        return Scaffold(
          body: child,
          bottomNavigationBar:
              CustomBottomNavBar(role: role, currentLocation: location),
        );
      },
      routes: [
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
                create: (context) => LocationBloc()
                  ..add(const LocationEvent.requestLocationPermission()),
              ),
            ],
            child: const HomePage(),
          ),
        ),
        GoRoute(
          name: 'product-page',
          path: '/product',
          builder: (context, state) => BlocProvider(
            create: (context) => ProductBloc()
              ..add(const ProductEvent.fetchAllCategoriesAndProducts()),
            child: const ProductPage(),
          ),
        ),
        GoRoute(
          name: "order-page",
          path: '/order',
          builder: (context, state) {
            return BlocProvider(
              create: (context) =>
                  MainOrderBloc()..add(const MainOrderEvent.started()),
              child: const OrderPage(),
            );
          },
        ),
        GoRoute(
          name: 'person-page',
          path: '/person',
          builder: (context, state) {
            return const PersonPage();
          },
        ),
        GoRoute(
          name: 'statistics-page',
          path: '/statistics',
          builder: (context, state) {
            return BlocProvider(
              create: (context) =>
                  StatisticsBloc()..add(const StatisticsEvent.started()),
              child: const StatisticsPage(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      name: 'branch-list',
      path: '/branch-list',
      builder: (context, state) {
        final address = SessionData.currentUserAddress;
        return BlocProvider(
          create: (context) => BranchBloc()
            ..add(
              address == null
                  ? const BranchEvent.getBranches()
                  : (address.location.coordinates.isEmpty)
                      ? const BranchEvent.getBranches()
                      : (BranchEvent.getBranchesNearby(
                          address.location.coordinates[0],
                          address.location.coordinates[1],
                        )),
            ),
          child: const BranchesPage(),
        );
      },
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
    GoRoute(
      name: 'user-management',
      path: '/user-management',
      builder: (context, state) => BlocProvider(
        create: (context) =>
            UserManagementBloc()..add(const UserManagementEvent.getAllUsers()),
        child: const UserManagementPage(),
      ),
    ),
    GoRoute(
      name: 'user-profile',
      path: '/user-profile',
      builder: (context, state) {
        final String role = state.uri.queryParameters['role'] ?? "User";
        final String userId = state.uri.queryParameters['userId'] ?? "";
        return BlocProvider(
          create: (context) => UserManagementBloc()
            ..add(UserManagementEvent.getUserById(userId)),
          child: UserProfilePage(
            role: role,
            userId: userId,
          ),
        );
      },
    ),
    GoRoute(
      name: 'change-password',
      path: '/change-password',
      builder: (context, state) => BlocProvider(
        create: (context) => ChangePasswordBloc(),
        child: const ChangePasswordPage(),
      ),
    ),
    GoRoute(
      name: 'create-order',
      path: "/create-order",
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              OrderBloc()..add(const OrderEvent.fetchAllCategory()),
          child: const CreateOrderPage(),
        );
      },
      routes: [
        GoRoute(
          name: 'confirm-order',
          path: 'confirm-order',
          builder: (context, state) {
            final bloc = state.extra as OrderBloc;
            final userName = state.uri.queryParameters['userName'] ?? "";
            final userPhone = state.uri.queryParameters['userPhone'] ?? "";
            final userAddress = state.uri.queryParameters['userAddress'] ?? "";
            final userNote = state.uri.queryParameters['userNote'] ?? "";
            return BlocProvider.value(
              value: bloc,
              child: ConfirmedOrderPage(
                userName: userName,
                userPhone: userPhone,
                userAddress: userAddress,
                userNote: userNote,
              ),
            );
          },
        ),
        GoRoute(
            name: 'success-order-page',
            path: 'success-order-page',
            builder: (context, state) => const SuccessOrderPage()),
      ],
    ),
    GoRoute(
      name: 'detailed-order-page',
      path: '/detailed-order-page',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final orderItem = extra['order'] as Order;
        final bloc = extra['bloc'] as MainOrderBloc;
        return BlocProvider.value(
          value: bloc,
          child: DetailedOrderPage(order: orderItem),
        );
      },
    ),
    GoRoute(
      name: "search-order-page",
      path: "/search-order",
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MainOrderBloc(),
          child: const SearchOrderPage(),
        );
      },
    ),
    GoRoute(
        name: 'chat-page',
        path: '/chat',
        builder: (context, state) {
          final String? conversationId =
              state.uri.queryParameters['conversationId'];
          return BlocProvider(
            create: (context) => ChatBloc()
              ..add(conversationId != null
                  ? ChatEvent.getMessages(conversationId)
                  : const ChatEvent.started()),
            child: ChatPage(
              conversationId: conversationId,
            ),
          );
        }),
    GoRoute(
      name: 'chat-list-page',
      path: '/chat-list',
      builder: (context, state) => BlocProvider(
        create: (context) =>
            ChatBloc()..add(const ChatEvent.getAllConversations()),
        child: const ChatListPage(),
      ),
    ),
  ],
);
