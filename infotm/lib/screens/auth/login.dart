//import 'package:infotm/services/auth.dart';
import 'package:infotm/ui_components/custom_button.dart';
import 'package:infotm/ui_components/custom_textfield.dart';
import 'package:infotm/ui_components/loading_snack_bar.dart';
import 'package:infotm/ui_components/ui_specs.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(AppMargins.S),
            child: Form(
              child: CustomTextField(
                label: "E-mail",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppMargins.S),
            child: Form(
              child: CustomTextField(
                label: "Password",
                isPassword: true,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(AppMargins.M),
              child: CustomButton(
                  onPressed: () async {
                    showLoadingSnackBar(context, "Logging in...",
                        color: AppColors.burntSienna, durationSeconds: 2);
                  },
                  text: "Sign-in")),
          Padding(
            padding: const EdgeInsets.all(AppMargins.S),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Don't have an account? Sign-up",
                  style: TextStyle(
                      fontSize: AppFontSizes.M, color: AppColors.burntSienna)),
            ),
          ),
        ]),
      )),
    );
  }
}
