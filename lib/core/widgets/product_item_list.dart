import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class ProductItemList extends StatelessWidget {
  final String productName;
  final String productCategory;
  final String productImage;
  final double productPrice;
  final String productDescription;
  const ProductItemList({
    super.key,
    required this.productName,
    required this.productCategory,
    this.productImage = "",
    required this.productPrice,
    this.productDescription = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: cardBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex:3,
            child: ClipRRect(
              borderRadius: cardBorderRadius,
              child: productImage != ""
                  ? Image.network(
                      "${Enviroment.baseUrl}$productImage",
                      fit: BoxFit.cover,
                      width: double.infinity - 80,
                      height: double.infinity,
                    )
                  : const Image(
                      image: AssetImage(logoApp),
                      fit: BoxFit.cover,
                      width: double.infinity - 80,
                      height: double.infinity,
                    ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: titleStyle,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    productCategory,
                    style: contentStyle,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Visibility(
                    visible: false,
                    child: Text(
                      productDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: contentStyle.copyWith(
                        fontSize: smallFontSize,
                        color: grayContentColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Giá thu: ${NumberFormat("#,###", "vi_VN").format(productPrice)}/kg",
                    style: contentStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
