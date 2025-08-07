import 'dart:math';

import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_response.dart';

class ExpandOrderBoard extends StatefulWidget {
  final List<DetailedOrderResponse> products;
  const ExpandOrderBoard({
    super.key,
    required this.products,
  });

  @override
  State<ExpandOrderBoard> createState() => _ExpandOrderBoardState();
}

class _ExpandOrderBoardState extends State<ExpandOrderBoard> {
  bool _isExpanded = false;
  final int _defaultItemCount = 2;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          shrinkWrap: true,
          itemCount: _isExpanded
              ? widget.products.length
              : min(widget.products.length, _defaultItemCount),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = widget.products[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: imageBorderRadius,
                  child: item.image == ""
                      ? Image.asset(
                          logoApp,
                          width: 70,
                          height: 70,
                        )
                      : Image.network(
                          "${Enviroment.baseUrl}${item.image}",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                ),
                const SizedBox(width: 13),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product?.name ?? "",
                      style: titleStyle,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "${item.amount.toString()} kg",
                      style: contentStyle.copyWith(
                        fontSize: 10.0,
                        color: darkGrayColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        if (widget.products.length > _defaultItemCount)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Thu gọn' : 'Xem thêm',
              style: contentStyle.copyWith(
                color: primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
