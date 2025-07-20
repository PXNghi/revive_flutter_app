import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "ĐĂNG NHẬP",
        isCenter: true,
        isLeadingImplied: false,
      ),
    );
  }
}
