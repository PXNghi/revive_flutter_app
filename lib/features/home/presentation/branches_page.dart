import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/branch_item.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/features/home/bloc/branch_bloc/branch_bloc.dart';

class BranchesPage extends StatelessWidget {
  const BranchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: ListView(
          children: [
            const Text(
              "KHU VỰC HOẠT ĐỘNG",
              style: headerStyle,
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<BranchBloc, BranchState>(builder: (context, state) {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.branches.length,
                itemBuilder: (context, index) {
                  return BranchListItem(
                    district: state.branches[index].district,
                    address: state.branches[index].address,
                    lat: state.branches[index].location.lat,
                    lon: state.branches[index].location.lon,
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
