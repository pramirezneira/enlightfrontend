import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/env.dart';
import 'package:enlight/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EnlightAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                EnlightTextFormField(
                  text: "Email",
                  controller: emailController,
                ),
                EnlightTextFormField(
                  text: "Password",
                  controller: passwordController,
                ),
                EnlightFormSubmissionButton(
                  text: "Sign in",
                  formKey: formKey,
                  onPressed: _onPressed,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password?"),
                )
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
            child: const Text("Don't have an account? Sign up."),
          ),
        ),
      ],
    );
  }

  void Function()? _onPressed() {
    http
        .get(
      Uri.http(
        server,
        "/account",
        {
          "email": emailController.text,
          "password": passwordController.text,
        },
      ),
    )
        .then((response) {
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password. Please try again."),
          ),
        );
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Placeholder()),
        (route) => false,
      );
    });
    return null;
  }
}
