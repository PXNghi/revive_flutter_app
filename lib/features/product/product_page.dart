import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Visibility(
                  child: MyIconButton(
                    icon: addIcon,
                    size: 30,
                  ),
                ),
                const Spacer(),
                MyIconButton(
                  icon: searchIcon,
                  size: 30,
                ),
                const SizedBox(width: 8.0),
                MyIconButton(
                  icon: filterIcon,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
