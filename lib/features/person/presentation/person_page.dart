import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/configs/routers/app_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_option_bar.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pageHorizontalPadding,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text("CÁ NHÂN", style: headerStyle),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      userDefaultImage,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      SessionData.mine?.name ?? "User Name",
                      style: contentStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              SessionData.mine?.role == "Admin"
                  ? _buildAdminOptions()
                  : SessionData.mine?.role == "User"
                      ? _buildUserOptions()
                      : _buildUnauthorziedOptions(),
            ],
          ),
        ),
      ),
    );
  }

  _buildAdminOptions() {
    return Column(
      children: [
        MyOptionBar(
          onTap: () {
            context.pushNamed('user-management');
          },
          label: "Quản lý người dùng",
        ),
        const SizedBox(height: 16.0),
        MyOptionBar(
          onTap: () {},
          label: "Danh sách chat",
        ),
        const SizedBox(height: 16.0),
        MyOptionBar(
          onTap: () {
            SessionData.logout();
            context.goNamed('login-page');
          },
          label: "Đăng xuất",
          isHasArrowRight: false,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  _buildUserOptions() {
    return Column(
      children: [
        MyOptionBar(
          onTap: () {},
          label: "Thay đổi thông tin cá nhân",
        ),
        const SizedBox(height: 16.0),
        MyOptionBar(
          onTap: () {},
          label: "Đổi mật khẩu",
        ),
        const SizedBox(height: 16.0),
        MyOptionBar(
          onTap: () {},
          label: "Hỗ trợ",
        ),
        const SizedBox(height: 16.0),
        MyOptionBar(
          onTap: () {},
          label: "Đăng xuất",
          isHasArrowRight: false,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  _buildUnauthorziedOptions() {
    return Column(
      children: [
        MyOptionBar(
          onTap: () {},
          label: "Hỗ trợ",
        ),
        const SizedBox(height: 16.0),
        MyOptionBar(
          onTap: () {},
          label: "Đăng nhập",
        ),
      ],
    );
  }
}
