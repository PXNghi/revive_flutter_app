import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/person/bloc/change_password/change_password_bloc.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is Success) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Đổi mật khẩu thành công"),
            ));
          }
          if (state is Error) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
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
          return Padding(
            padding: pageHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ĐỔI MẬT KHẨU",
                  style: headerStyle,
                ),
                const SizedBox(height: 32.0),
                MyTextField(
                  controller: oldPasswordController,
                  isPassword: true,
                  label: "Mật khẩu hiện tại",
                  errorText:
                      (state is ValidateFailed) ? state.oldPasswordError : null,
                ),
                const SizedBox(height: 16.0),
                MyTextField(
                  controller: newPasswordController,
                  isPassword: true,
                  label: "Mật khẩu mới",
                  errorText:
                      (state is ValidateFailed) ? state.newPasswordError : null,
                ),
                const SizedBox(height: 16.0),
                MyTextField(
                  controller: confirmPasswordController,
                  isPassword: true,
                  label: "Xác nhận mật khẩu mới",
                  errorText: (state is ValidateFailed)
                      ? state.confirmedPasswordError
                      : null,
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: MyButton(
                    label: "Đổi mật khẩu",
                    onTap: () {
                      context.read<ChangePasswordBloc>().add(
                            ChangePasswordEvent.changePassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                              confirmPasswordController.text,
                            ),
                          );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
