import 'package:infotm/screens/home/home.dart';
import 'package:infotm/services/isar.dart';
import 'package:infotm/ui_components/menu_button.dart';
import 'package:infotm/ui_components/ui_specs.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool showHome;
  const CustomAppBar({Key? key, this.showHome = true}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.sunset,
      toolbarHeight: 50,
      leading: showHome
          ? MenuButton(
              icon: Icons.home,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            )
          : Container(),
      actions: [
        IsarService.getAdminStatus()
            ? MenuButton(
                icon: Icons.add_location_alt_outlined,
                text: "Add sensor",
                onTap: () async {
                  Navigator.pushNamed(context, '/add-sensor');
                })
            : Container(),
        const Padding(padding: EdgeInsets.all(AppMargins.XS))
      ],
    );
  }
}
