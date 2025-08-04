import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/order_product_item.dart';
import 'package:revive_flutter_project/features/order/models/added_list_product.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_model.dart';

class ExpandProduct extends StatefulWidget {
  final List<AddedListProduct>? cart;
  final Function(DetailedOrder)? onDelete;

  const ExpandProduct({
    super.key,
    this.cart,
    this.onDelete,
  });

  @override
  State<ExpandProduct> createState() => _ExpandProductState();
}

class _ExpandProductState extends State<ExpandProduct> {
  bool _isExpanded = false;
  final int _defaultItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart ?? [];
    final int displayCount =
        _isExpanded ? cart.length : (_defaultItemCount.clamp(0, cart.length));

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        border: Border.all(color: primaryColor),
        color: primaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < displayCount; i++)
            Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: OrderProductItem(
                    productName: cart[i].productName,
                    categoryName: cart[i].categoryName,
                    imagePath: cart[i].detailedOrder.image,
                    amount: cart[i].detailedOrder.amount,
                    onDeleteTap: widget.onDelete != null
                        ? () => widget.onDelete!(cart[i].detailedOrder)
                        : null,
                  ),
                );
              },
            ),
          if (cart.length > _defaultItemCount)
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(_isExpanded ? 'Thu gọn' : 'Xem thêm'),
            ),
        ],
      ),
    );
  }
}
