import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/page/details.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/sharedPref.dart';
import '../service/utilites.dart';
import '../widget/custom_text.dart';
import '../widget/text_button.dart';
import 'home.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool accountValid = false;
  bool passwordValid = false;
  bool confirmValid = false;

  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 20,
          ),
          customText(AppColor.black, "註冊頁面", 40, true),
          const SizedBox(
            height: 20,
          ),
          customText(AppColor.black, "帳號", 25, true),
          const SizedBox(
            height: 20,
          ),
          accountTextForm(),
          const SizedBox(
            height: 20,
          ),
          customText(AppColor.black, "密碼", 25, true),
          const SizedBox(
            height: 20,
          ),
          passwordTextForm(),
          const SizedBox(
            height: 20,
          ),
          confirmTextForm(),
          const SizedBox(
            height: 20,
          ),
          registerButton(),
          const SizedBox(
            height: 20,
          ),
          registerToLogin()
        ]),
      ),
    );
  }

  Widget registerButton() {
    return customTextButton(Colors.black, "登入", 30, () async {
      bool result =
          await Auth.hasAccountBeenRegistered(account_controller.text);
      if (accountValid && passwordValid && confirmValid) {
        if (result) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()));
            Utilites.showSnackBar(context, "註冊過了老哥");
          }
        } else {
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DetailsPage(
                    account: account_controller.text,
                    password: password_controller.text)));
          }
        }
      } else {
        if (mounted) {
          Utilites.showSnackBar(context, "確認輸入拉");
        }
      }
    });
  }

  Widget registerToLogin() {
    return Column(
      children: [
        customText(AppColor.black, "已經擁有帳號?", 20, false),
        InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage())),
          child: customText(AppColor.darkBlue, "登入", 35, true),
        )
      ],
    );
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: account_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            accountValid = false;
            return "pls enter somethibg bro";
          } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
              .hasMatch(value)) {
            accountValid = false;
            return "格式阿老哥";
          } else {
            accountValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "account",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  bool obscure = false;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: password_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            passwordValid = false;
            return "pls enter somethibg bro";
          } else {
            passwordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure = !obscure;
                    }),
                icon: obscure
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility))),
      ),
    );
  }

  bool obscure2 = false;
  Widget confirmTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: confirm_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != password_controller.text) {
            confirmValid = false;
            return "pls check ur password input man";
          } else if (value == null || value.trim().isEmpty) {
            confirmValid = false;
            return "pls enter somethibg bro";
          } else {
            confirmValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "confirm your password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure2 = !obscure2;
                    }),
                icon: obscure2
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility))),
      ),
    );
  }
}
