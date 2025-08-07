import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class ProductItem extends StatelessWidget {
  final String image;
  final String productName;
  final String productCategory;
  final double productPrice;
  const ProductItem({
    this.image = "",
    this.productName = "",
    this.productCategory = "",
    this.productPrice = 0.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: cardBorderRadius,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              ),
              child: image != ""
                  ? Image.network(
                      "${Enviroment.baseUrl}$image",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : const Image(
                      image: AssetImage(bannerImage),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              width: screenSize.width * 0.6,
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
                    const Spacer(),
                    Text(
                      "Giá thu: ${NumberFormat("#,###", "vi_VN").format(productPrice)}/kg",
                      style: contentStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
