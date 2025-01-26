// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.lightBlueAccent,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.graphic_eq), // Your logo or icon here
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
            onPressed: () {
              // Add your 'Refer Now' button logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Replaces primary
              foregroundColor: Colors.black, // Replaces onPrimary
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text('REFER NOW'),
                Icon(Icons.arrow_forward), // No space after the icon
              ],
            ),
          ),
        ),
      ],
    );
  }
}