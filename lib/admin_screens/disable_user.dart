import 'package:flutter/material.dart';
import 'package:wash_mesh/global_variables/global_variables.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

class DisableUser extends StatefulWidget {
  const DisableUser({super.key});

  @override
  State<DisableUser> createState() => _DisableUserState();
}

class _DisableUserState extends State<DisableUser> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        ch: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Text(
              "Your account is restricted from admin".toTitleCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ),
        ]),
        op: 0.1);
  }
}
