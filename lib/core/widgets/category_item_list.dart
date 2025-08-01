import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';

class CategoryItemList extends StatefulWidget {
  final Category? category;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const CategoryItemList({
    super.key,
    this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<CategoryItemList> createState() => _CategoryItemListState();
}

class _CategoryItemListState extends State<CategoryItemList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onTap ?? () {},
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: widget.isSelected ? Border.all(color: Colors.green, width: 2) : null,
                image: widget.category?.image != "" ? DecorationImage(
                  image: NetworkImage("${Enviroment.baseUrl}${widget.category!.image}"),
                  fit: BoxFit.cover,
                ) : const DecorationImage(image: AssetImage(logoApp)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              widget.category?.name ?? "Unknown",
              overflow: TextOverflow.ellipsis,
              style: contentStyle.copyWith(fontSize: smallFontSize),
            ),
          ),
        ],
      ),
    );
  }
}
