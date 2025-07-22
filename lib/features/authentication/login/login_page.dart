import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/authentication/login/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppbar(
        title: "ĐĂNG NHẬP",
        titleStyle: headerStyle.copyWith(color: Colors.black),
        isCenter: true,
        isLeadingImplied: false,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is LoginSuccess) {
                  Navigator.of(context).pop();
                }
                if (state is LoginError) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      MyTextField(
                        controller: emailController,
                        label: "Email:",
                        errorText:
                            (state is LoginLoaded) ? state.emailError : null,
                      ),
                      const SizedBox(height: 24.0),
                      MyTextField(
                        controller: passwordController,
                        label: "Mật khẩu:",
                        isPassword: true,
                        errorText:
                            (state is LoginLoaded) ? state.passwordError : null,
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.go('/forget-password');
                          },
                          child: const Text(
                            "Quên mật khẩu",
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
                          context.read<LoginBloc>().add(
                                LoginEvent.validateInformations(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        },
                        label: "Đăng nhập",
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bạn chưa có tài khoản? ",
                  style: contentStyle.copyWith(
                    fontSize: smallFontSize,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("register clicked");
                    context.pushNamed('register');
                  },
                  child: Text(
                    "Đăng ký ngay!",
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
      ),
    );
  }
}
