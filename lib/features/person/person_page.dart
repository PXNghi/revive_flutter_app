import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text("CÁ NHÂN", style: headerStyle),
              ),
              const SizedBox(height: 16.0),
              
            ],
          ),
        ),
      ),
    );
  }
}