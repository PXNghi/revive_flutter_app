import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/services/socket_service.dart';
import 'package:revive_flutter_project/features/person/user_usecases.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final UserUsecases _userUsecases = UserUsecases();
  final SocketService _socketService = SocketService();

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  Future<void> _checkLogin() async {
    final token = await SessionData.token();
    if (token.isEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        context.goNamed('login-page');
      });
    } else {
      ApiService.authorizeHeader(token);
      final response  = await _userUsecases.getUserProfileByToken(token);
      if (response['success'] == true) {
        SessionData.login(token, response["data"]);
        _socketService.connect(SessionData.mine!.id);
        context.goNamed('home-page');
      } else {
        SessionData.logout();
        context.goNamed('login-page');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(logoApp),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  
}
