import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_user_bar.dart';
import 'package:revive_flutter_project/features/person/bloc/user_management/user_management_bloc.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: ListView(
          children: [
            Text(
              "Quản lý người dùng".toUpperCase(),
              style: headerStyle,
            ),
            const SizedBox(height: 32.0),
            BlocBuilder<UserManagementBloc, UserManagementState>(
              builder: (context, state) {
                if (state is Loaded) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return UserInformationBar(
                        userId: user.id,
                        userName: user.name,
                        isChatList: false,
                        onEditTap: () {},
                        onActivateTap: () {},
                      );
                    },
                    itemCount: state.users.length,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
