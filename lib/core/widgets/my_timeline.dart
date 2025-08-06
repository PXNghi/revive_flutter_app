import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyTimeline extends StatelessWidget {
  final String currentStatus;

  MyTimeline({required this.currentStatus});

  final List<String> statusList = [
    "waiting",
    "confirmed",
    "delivering",
    "completed",
  ];

  final List<String> statusTextList = [
    "Chờ xử lý",
    "Đã xác nhận",
    "Đang đi lấy",
    "Đã hoàn thành",
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = statusList.indexOf(currentStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double dotSize = 14;
              double spacing =
                  (constraints.maxWidth - dotSize) / (statusList.length - 1);

              return Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: dotSize / 2 - 1,
                        left: 0,
                        right: 0,
                        child: Row(
                          children:
                              List.generate(statusList.length - 1, (index) {
                            final isActive = index < currentIndex;
                            return Expanded(
                              child: Container(
                                height: 2,
                                color: isActive
                                    ? primaryColor
                                    : Colors.grey.shade300,
                              ),
                            );
                          }),
                        ),
                      ),

                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(statusList.length, (index) {
                          final isActive = index <= currentIndex;
                          return Container(
                            width: dotSize,
                            height: dotSize,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? primaryColor
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(statusList.length, (index) {
                      final isCurrent = index == currentIndex;
                      return SizedBox(
                        width: 65,
                        child: Text(
                          statusTextList[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isCurrent ? FontWeight.w600 : FontWeight.normal,
                            color: isCurrent ? Colors.green : Colors.black,
                            fontFamily: montFont,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
