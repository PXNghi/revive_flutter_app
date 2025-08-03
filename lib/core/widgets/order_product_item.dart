import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';

class OrderProductItem extends StatelessWidget {
  final String productName;
  final String categoryName;
  final String imagePath;
  final double amount;
  final bool isEditMode;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onEditTap;
  const OrderProductItem({
    super.key,
    required this.productName,
    required this.categoryName,
    this.imagePath = "",
    this.amount = 0.0,
    this.isEditMode = true,
    this.onDeleteTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: cardBorderRadius,
          child: Image.asset(
            imagePath == "" ? logoApp : imagePath,
            height: 90,
            width: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    productName,
                    style: titleStyle,
                  ),
                  const Spacer(),
                  MyIconButton(
                    size: 24.0,
                    icon: deleteIcon,
                    onTap: onDeleteTap,
                  ),
                  const SizedBox(width: 10.0),
                  MyIconButton(
                    size: 24.0,
                    icon: editIcon,
                    onTap: onEditTap,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryName,
                    style: contentStyle,
                  ),
                  Text(
                    "$amount kg",
                    style: contentStyle,
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}