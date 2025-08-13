
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/authentication/register/bloc/register_bloc.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: MyAppbar(
        title: "XÁC NHẬN ĐĂNG KÝ",
        titleStyle: headerStyle.copyWith(color: Colors.black),
        isCenter: true,
        isLeadingImplied: false,
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is Success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Đăng ký thành công!"),
            ));
            context.pushNamed('login-page');
          }
          if (state is ResendOTPSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Gửi lại thành công! Vui lòng kiểm tra email"),
            ));
          }
          if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        child: Padding(
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
                    TextSpan(
                      text: "Mã OTP đã được gửi qua email ",
                      style: contentStyle.copyWith(fontSize: smallFontSize),
                    ),
                    TextSpan(
                      text: widget.email,
                      style: contentStyle.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: smallFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Vui lòng không được gửi mã cho bất kỳ ai!",
                style: contentStyle.copyWith(fontSize: smallFontSize),
              ),
              const SizedBox(height: 24),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      MyTextField(
                        controller: otpController,
                        label: "OTP:",
                        errorText: state.otpError,
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            print("resend otp");
                            context.read<RegisterBloc>().add(
                                RegisterEvent.resendOTP(email: widget.email));
                          },
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
                          print("verify account");
                          context.read<RegisterBloc>().add(
                                RegisterEvent.verifyAccount(
                                  otp: otpController.text,
                                  email: widget.email,
                                ),
                              );
                        },
                        label: "Đăng ký",
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
