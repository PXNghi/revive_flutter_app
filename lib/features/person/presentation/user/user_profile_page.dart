import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/person/bloc/user_management/user_management_bloc.dart';

class UserProfilePage extends StatefulWidget {
  final String role;
  final String userId;
  const UserProfilePage({
    super.key,
    required this.role,
    required this.userId,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: BlocConsumer<UserManagementBloc, UserManagementState>(
          listener: (context, state) {
            if (state is Error) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is Loaded && state.message != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (context, state) {
            if (state is Loaded) {
              return ListView(
                children: [
                  const Text(
                    "HỒ SƠ NGƯỜI DÙNG",
                    style: headerStyle,
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Image.asset(
                      userDefaultImage,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onDoubleTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Bạn không thể chỉnh sửa email"),
                        ),
                      );
                    },
                    child: MyTextField(
                      label: "Email",
                      isReadOnly: true,
                      initialValue: state.user?.email ?? "",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  MyTextField(
                    controller: nameController,
                    label: "Họ và tên",
                    initialValue: state.user?.name ?? "",
                  ),
                  const SizedBox(height: 16.0),
                  MyTextField(
                    controller: phoneController,
                    label: "Số điện thoại",
                    initialValue: state.user?.phone ?? "",
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Địa chỉ", style: contentStyle),
                  const SizedBox(height: 8.0),
                  state.user != null && state.user!.addresses.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8.0),
                          itemCount: state.user?.addresses.length ?? 0,
                          itemBuilder: (context, index) {
                            final address = state.user!.addresses[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(address.address),
                                ],
                              ),
                            );
                          },
                        )
                      : Row(
                          children: [
                            Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                SessionData.currentUserAddress?.address ?? "",
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 42.0),
                  Center(
                    child: MyButton(
                      label: "Cập nhật",
                      onTap: () {
                        context.read<UserManagementBloc>().add(
                              UserManagementEvent.updateUserProfileById(
                                widget.userId,
                                nameController.text.isEmpty
                                    ? state.user!.name
                                    : nameController.text,
                                phoneController.text.isEmpty
                                    ? state.user!.phone
                                    : phoneController.text,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
