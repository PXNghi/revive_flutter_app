import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';

class RegisterOTPPage extends StatefulWidget {
  final String email;
  const RegisterOTPPage({super.key, required this.email});

  @override
  State<RegisterOTPPage> createState() => _RegisterOTPPageState();
}

class _RegisterOTPPageState extends State<RegisterOTPPage> {
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "XÁC NHẬN ĐĂNG KÝ",
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Mã OTP đã được gửi qua email ",
                    style: contentStyle,
                  ),
                  TextSpan(
                    text: widget.email,
                    style: contentStyle.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Vui lòng không được gửi mã cho bất kỳ ai!",
              style: contentStyle,
            ),
            const SizedBox(height: 24),
            MyTextField(
              controller: otpController,
              label: "OTP:",
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "Gửi lại",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: montFont,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 45),
            MyButton(
              onTap: () {
                context.go('/login');
              },
              label: "Đăng ký",
            ),
          ],
        ),
      ),
    );
  }
}
