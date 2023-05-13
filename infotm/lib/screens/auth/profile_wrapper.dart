import 'package:flutter/material.dart';
import 'package:infotm/screens/auth/login.dart';
import 'package:infotm/screens/auth/profile.dart';
import 'package:infotm/services/isar.dart';

class ProfileWrapper extends StatefulWidget {
  const ProfileWrapper({super.key});

  @override
  State<ProfileWrapper> createState() => _ProfileWrapperState();
}

class _ProfileWrapperState extends State<ProfileWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (IsarService.isarUser.uid.isNotEmpty) {
      return const ProfilePage();
    } else {
      return const LoginPage();
    }
  }
}
