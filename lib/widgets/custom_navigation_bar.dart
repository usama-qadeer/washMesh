import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:wash_mesh/user_screens/user_booking_screen.dart';
import 'package:wash_mesh/user_screens/user_home_screen.dart';
import 'package:wash_mesh/user_screens/user_settings.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';
import 'package:wash_mesh/widgets/wash_mesh_dialog.dart';

import '../user_chat_module/user_chat_app.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  List pages = [
    const UserBookingScreen(),
    const WashMeshDialog(),
    const UserHomeScreen(),
    const UserChatApp(),
    const UserSettings(),
  ];

  int currentIndex = 2;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: CustomColor().mainTheme,
        // color: Colors.amber,
        // gradient: LinearGradient(colors: [Colors.black12, Colors.red]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          index: currentIndex,
          animationDuration: const Duration(milliseconds: 300),
          onTap: onTap,
          items: [
            Icon(
              Icons.event_note_outlined,
              color: CustomColor().mainColor,
              // color: Colors.green,
            ),
            Icon(
              Icons.category_outlined,
              color: CustomColor().mainColor,
            ),
            Icon(
              Icons.home,
              color: CustomColor().mainColor,
            ),
            Icon(
              Icons.chat_bubble_outlined,
              color: CustomColor().mainColor,
            ),
            Icon(
              Icons.settings,
              color: CustomColor().mainColor,
            ),
          ],
        ),
        body: pages[currentIndex],
      ),
    );
  }
}
