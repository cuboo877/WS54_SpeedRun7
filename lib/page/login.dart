import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/page/home.dart';
import 'package:ws54_flutter_speedrun7/page/register.dart';
import 'package:ws54_flutter_speedrun7/service/auth.dart';
import 'package:ws54_flutter_speedrun7/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun7/service/utilites.dart';
import 'package:ws54_flutter_speedrun7/widget/text_button.dart';

import '../constant/style_guide.dart';
import '../widget/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  bool accountValid = false;
  bool passwordValid = false;
  bool doAuthWarning = false;

  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
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
          customText(AppColor.black, "登入頁面", 40, true),
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
          loginButton(),
          const SizedBox(
            height: 20,
          ),
          loginToRegister()
        ]),
      ),
    );
  }

  Widget loginButton() {
    return customTextButton(Colors.black, "登入", 30, () async {
      bool result = await Auth.loginAuth(
          account_controller.text, password_controller.text);
      if (accountValid && passwordValid) {
        if (result) {
          String userID = await SharedPref.getLoggedUserID();
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: userID)));
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
          if (mounted) {
            Utilites.showSnackBar(context, "登入失敗");
          }
        }
      } else {
        if (mounted) {
          Utilites.showSnackBar(context, "檢查你的輸入阿");
        }
      }
    });
  }

  Widget loginToRegister() {
    return Column(
      children: [
        customText(AppColor.black, "尚未擁有帳號?", 20, false),
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
          child: customText(AppColor.darkBlue, "註冊", 35, true),
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
        onChanged: (value) {
          setState(() {
            doAuthWarning = false;
          });
        },
        validator: (value) {
          if (doAuthWarning) {
            accountValid = false;
            return "";
          } else if (value == null || value.trim().isEmpty) {
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
        onChanged: (value) {
          setState(() {
            doAuthWarning = false;
          });
        },
        validator: (value) {
          if (doAuthWarning) {
            passwordValid = false;
            return "wrong account or password";
          } else if (value == null || value.trim().isEmpty) {
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
}
