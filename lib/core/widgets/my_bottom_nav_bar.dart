import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String role;
  final String currentLocation;

  const CustomBottomNavBar({
    super.key,
    required this.role,
    required this.currentLocation,
  });

  final _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final tabs = <_TabItem>[
      _TabItem(label: 'Trang chủ', iconPath: homeIcon, route: '/home'),
      _TabItem(label: 'Bảng giá', iconPath: orderIcon, route: '/product'),
      _TabItem(label: 'Đơn hàng', iconPath: cartIcon, route: '/order'),
      _TabItem(label: 'Cá nhân', iconPath: personIcon, route: '/person'),
      if (role == "Admin")
        _TabItem(label: 'Thống kê', iconPath: graphIcon, route: '/stat'),
    ];

    final currentIndex =
        tabs.indexWhere((t) => currentLocation.startsWith(t.route));
    final safeIndex = currentIndex < 0 ? 0 : currentIndex;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: safeIndex,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      backgroundColor: Colors.white,
      unselectedItemColor: grayContentColor,
      selectedItemColor: primaryColor,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: montFont,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: montFont,
      ),
      onTap: (index) {
        final targetRoute = tabs[index].route;

        if (targetRoute != currentLocation) {
          context.go(targetRoute);
        }
      },
      items: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isSelected = index == currentIndex;

        final icon = SvgPicture.asset(
          tab.iconPath,
          width: _iconSize,
          height: _iconSize,
          color: isSelected ? primaryColor : grayContentColor,
        );

        return BottomNavigationBarItem(
          label: tab.label,
          icon: icon,
          activeIcon: icon,
        );
      }).toList(),
    );
  }
}

class _TabItem {
  final String label;
  final String iconPath;
  final String route;

  _TabItem({
    required this.label,
    required this.iconPath,
    required this.route,
  });
}
