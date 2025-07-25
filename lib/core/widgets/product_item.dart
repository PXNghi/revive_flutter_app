import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class ProductItem extends StatelessWidget {
  final String image;
  final String productName;
  final String productCategory;
  final String productPrice;
  const ProductItem({
    this.image = "",
    this.productName = "",
    this.productCategory = "",
    this.productPrice = "",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.6,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(defaultBorderRadius),
              topRight: Radius.circular(defaultBorderRadius),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: screenSize.width * 0.6,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(defaultBorderRadius),
                bottomRight: Radius.circular(defaultBorderRadius),
              ),
              border: Border(
                bottom: BorderSide(color: primaryColor),
                left: BorderSide(color: primaryColor),
                right: BorderSide(color: primaryColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName.toUpperCase(),
                    style: titleStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    productCategory,
                    style: contentStyle,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Giá thu: $productPrice/kg",
                    style: contentStyle.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}