import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_user_bar.dart';
import 'package:revive_flutter_project/features/person/bloc/user_management/user_management_bloc.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: BlocListener<UserManagementBloc, UserManagementState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return UserInformationBar(
                          userId: user.id,
                          userName: user.name,
                          isChatList: false,
                          isActive: user.isActive,
                          onEditTap: () async {
                            final shouldRefresh = await context.pushNamed(
                              'user-profile',
                              queryParameters: {
                                'role': user.role,
                                'userId': user.id,
                              },
                            );

                            if (shouldRefresh == true) {
                              context
                                  .read<UserManagementBloc>()
                                  .add(const UserManagementEvent.getAllUsers());
                            }
                          },
                          onActivateTap: () {
                            _showWarningDialog(context, user);
                          },
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
      ),
    );
  }

  void _showWarningDialog(BuildContext context, User user) {
    final bloc = context.read<UserManagementBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            insetPadding: pageHorizontalPadding,
            child: Container(
              padding: pageHorizontalPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: BlocBuilder<UserManagementBloc, UserManagementState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: primaryColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          "CẢNH BÁO",
                          style: titleStyle.copyWith(
                            fontSize: 20,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        user.isActive
                            ? "Bạn có chắc muốn vô hiệu hóa tài khoản này?"
                            : "Bạn có muốn mở khóa tài khoản này?",
                        style: contentStyle,
                      ),
                      Text(
                        user.name,
                        style: contentStyle.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              label: "Yes",
                              onTap: () {
                                if (user.isActive) {
                                  context.read<UserManagementBloc>().add(
                                      UserManagementEvent.deactivateUser(
                                          user.id));
                                } else {
                                  context.read<UserManagementBloc>().add(
                                      UserManagementEvent.activateUser(
                                          user.id));
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: MyButton(
                              label: "Đóng",
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
