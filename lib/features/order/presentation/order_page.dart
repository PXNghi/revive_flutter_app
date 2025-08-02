import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "",
        isLeadingImplied: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: MyIconButton(
              icon: addIcon,
              size: 30.0,
              onTap: () {
                context.pushNamed('create-order');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          children: [
            Text(
              "ĐƠN HÀNG CỦA BẠN",
              style: headerStyle,
            ),
            
          ],
        ),
      ),
    );
  }
}
