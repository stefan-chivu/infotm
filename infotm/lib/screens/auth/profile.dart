import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:infotm/services/auth.dart';
import 'package:infotm/ui_components/custom_app_bar.dart';
import 'package:infotm/ui_components/custom_nav_bar.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: AppMargins.XXL,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.33,
              child: Expanded(
                  child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.burntSienna),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await AuthService().signOut();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  }
                },
                label: const Text(
                  'Sign-out',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )),
            ),
          ]),
          const Padding(padding: EdgeInsets.all(AppMargins.L)),
        ],
      )),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
