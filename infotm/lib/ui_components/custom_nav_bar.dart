import 'package:flutter/material.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.davyGray,
      showUnselectedLabels: true,
      iconSize: AppFontSizes.XL,
      selectedFontSize: AppFontSizes.L,
      unselectedFontSize: AppFontSizes.L,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: AppColors.davyGray),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: AppColors.davyGray),
      ],
      onTap: ((index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      }),
    );
  }
}
