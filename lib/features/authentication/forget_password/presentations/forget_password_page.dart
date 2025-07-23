import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/bloc/forget_password_bloc.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppbar(
        title: "Quên mật khẩu".toUpperCase(),
        titleStyle: headerStyle.copyWith(color: Colors.black),
        isCenter: true,
        isLeadingImplied: false,
      ),
      body: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetSuccess) {
            Navigator.of(context).pop();
            context.pushNamed('reset-password', queryParameters: {
              'email': emailController.text,
            });
          }
          if (state is ForgetError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
          if (state is SendOTPSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Gửi OTP thành công! Vui lòng kiểm tra email"),
            ));
          }
          if (state is ForgetLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
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
                  controller: emailController,
                  label: "Email:",
                  errorText: state.emailError,
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      print("Sending otp");
                      context.read<ForgetPasswordBloc>().add(
                            ForgetPasswordEvent.validateEmail(
                              emailController.text,
                            ),
                          );
                    },
                    child: const Text(
                      "Gửi OTP",
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: montFont,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                MyTextField(
                  controller: otpController,
                  label: "OTP:",
                  errorText: state.otpError,
                ),
                const SizedBox(height: 45),
                MyButton(
                  onTap: () {
                    context.read<ForgetPasswordBloc>().add(
                          ForgetPasswordEvent.validateOTP(
                            otpController.text,
                          ),
                        );
                  },
                  label: "Tiếp tục",
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn đã có tài khoản? ",
                      style: contentStyle.copyWith(
                        fontSize: smallFontSize,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: Text(
                        "Đăng nhập ngay!",
                        style: contentStyle.copyWith(
                          color: primaryColor,
                          fontSize: smallFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
