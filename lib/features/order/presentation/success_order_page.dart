import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';

class SuccessOrderPage extends StatelessWidget {
  const SuccessOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: pageHorizontalPadding,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child: Text(
                  "TẠO ĐƠN THÀNH CÔNG",
                  style: headerStyle.copyWith(fontSize: 25.0),
                ),
              ),
              const SizedBox(height: 45),
              Image.asset(checkSuccessImage, height: 100, width: 100),
              const SizedBox(height: 45),
              Text(
                "Bạn có thể chat hoặc điện số hotline để được hỗ trợ nếu có bất cứ vấn đề gì với đơn hàng.\n\nHotline: 0123456789",
                textAlign: TextAlign.center,
                style: contentStyle.copyWith(fontSize: 18.0),
              ),
              const SizedBox(height: 55),
              MyButton(
                label: "Về trang chủ",
                onTap: () {
                  context.goNamed('home-page');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
