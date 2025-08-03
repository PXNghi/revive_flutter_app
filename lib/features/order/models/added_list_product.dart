import 'package:revive_flutter_project/features/order/models/detailed_order_model.dart';

class AddedListProduct {
  final DetailedOrder detailedOrder;
  final double quantity;
  final String productName;
  final String categoryName;

  AddedListProduct({
    required this.detailedOrder,
    this.quantity = 0.0,
    required this.productName,
    required this.categoryName,
  });
}
