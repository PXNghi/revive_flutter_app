import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchListItem extends StatelessWidget {
  final String district;
  final String address;
  final double distance;
  final double lat;
  final double lon;
  const BranchListItem({
    super.key,
    required this.district,
    required this.address,
    this.distance = 0.0,
    required this.lat,
    required this.lon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: cardBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            district,
            style: titleStyle,
          ),
          const SizedBox(height: 12.0),
          Text(
            address,
            style: contentStyle,
          ),
          Visibility(
            visible: distance != 0.0,
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                Text(
                  "${distance.toStringAsFixed(2)} km",
                  style: contentStyle.copyWith(fontSize: 12.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Image.asset(redLocationIcon),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: () {
                  _openMap(context, lat, lon);
                },
                child: const Text(
                  "Hướng dẫn đi",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: primaryColor,
                    fontFamily: montFont,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openMap(BuildContext context, double lat, double lon) async {
    final Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Không thể mở Google Map",
          ),
        ),
      );
    }
  }
}
