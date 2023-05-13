import 'package:infotm/services/auth.dart';
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
  final AuthService _auth = AuthService();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppMargins.L, vertical: AppMargins.M),
            child: Image.asset(
              "assets/images/logo.png",
              width: 500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppMargins.S),
            child: Form(
              key: _emailFormKey,
              child: CustomTextField(
                label: "E-mail",
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "E-mail address is required";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(val)) {
                    return "Enter a valid e-mail address";
                  }
                  return null;
                },
                controller: _emailController,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppMargins.S),
            child: Form(
              key: _passwordFormKey,
              child: CustomTextField(
                label: "Password",
                isPassword: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                controller: _passwordController,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(AppMargins.M),
              child: CustomButton(
                  onPressed: () async {
                    showLoadingSnackBar(context, "Logging in...",
                        color: AppColors.airBlue, durationSeconds: 2);
                    if (_emailFormKey.currentState!.validate() &&
                        _passwordFormKey.currentState!.validate()) {
                      String result = await _auth.signInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                      if (mounted) {
                        if (!result.contains("success")) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(result)));
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        }
                      }
                    }
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
