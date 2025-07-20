import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "ĐỔI MẬT KHẨU",
        titleStyle: headerStyle.copyWith(color: Colors.black),
        isCenter: true,
        isLeadingImplied: false,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(logoApp),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            MyTextField(
              controller: passwordController,
              label: "Mật khẩu:",
            ),
            const SizedBox(height: 24.0),
            MyTextField(
              controller: confirmPasswordController,
              label: "Xác nhận mật khẩu:",
              isPassword: true,
            ),
            const SizedBox(height: 45),
            MyButton(
              onTap: () {
                context.go('/login');
              },
              label: "Đổi mật khẩu",
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
