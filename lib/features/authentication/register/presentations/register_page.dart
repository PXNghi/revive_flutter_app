import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/authentication/register/bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "ĐĂNG KÝ",
        titleStyle: headerStyle.copyWith(color: Colors.black),
        isCenter: true,
        isLeadingImplied: false,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: SingleChildScrollView(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is Loaded) {
                context.go('/confirm-otp-register');
              }
              if (state is Error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is Loading) {
                showDialog(
                  context: context,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
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
                  const SizedBox(height: 24.0),
                  MyTextField(
                    controller: fullNameController,
                    label: "Họ và tên:",
                  ),
                  const SizedBox(height: 24.0),
                  MyTextField(
                    controller: emailController,
                    label: "Email:",
                  ),
                  const SizedBox(height: 24.0),
                  MyTextField(
                    controller: passwordController,
                    label: "Mật khẩu:",
                    isPassword: true,
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
                      // context.read<RegisterBloc>().add(
                      //       RegisterEvent.register(
                      //         name: fullNameController.text,
                      //         email: emailController.text,
                      //         password: passwordController.text,
                      //         confirmedPassword: confirmPasswordController.text,
                      //       ),
                      //     );
                      context.pushNamed('confirm-otp-register?email=${emailController.text}');
                    },
                    label: "Đăng ký",
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
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
                            context.pop();
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
