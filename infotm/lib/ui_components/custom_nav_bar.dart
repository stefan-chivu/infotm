import 'package:flutter/material.dart';
import 'package:infotm/services/isar.dart';
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
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: AppColors.davyGray),
        const BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore_outlined),
            label: "Plan trip",
            backgroundColor: AppColors.davyGray),
        BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: IsarService.isarUser.uid.isNotEmpty ? "Profile" : "Log-in",
            backgroundColor: AppColors.davyGray),
      ],
      onTap: ((index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/plan-trip');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      }),
    );
  }
}
