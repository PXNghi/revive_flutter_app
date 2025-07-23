import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/authentication/forget_password/bloc/forget_password_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppbar(
        title: "ĐỔI MẬT KHẨU",
        titleStyle: headerStyle.copyWith(color: Colors.black),
        isCenter: true,
        isLeadingImplied: false,
      ),
      body: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            Navigator.pop(context);
            context.go('/');
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Đổi mật khẩu thành công"),
            ));
          }
          if (state is ForgetLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          }
          if (state is ForgetError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
                  controller: passwordController,
                  label: "Mật khẩu:",
                  isPassword: true,
                  errorText: state.passwordError,
                ),
                const SizedBox(height: 24.0),
                MyTextField(
                  controller: confirmPasswordController,
                  label: "Xác nhận mật khẩu:",
                  isPassword: true,
                  errorText: state.confirmPasswordError,
                ),
                const SizedBox(height: 45),
                MyButton(
                  onTap: () {
                    context.read<ForgetPasswordBloc>().add(
                          ForgetPasswordEvent.validatePassword(
                            widget.email,
                            passwordController.text,
                            confirmPasswordController.text,
                          ),
                        );
                  },
                  label: "Đổi mật khẩu",
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
