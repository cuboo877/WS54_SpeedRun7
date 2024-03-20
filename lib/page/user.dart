import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/page/home.dart';
import 'package:ws54_flutter_speedrun7/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun7/service/sql_service.dart';
import 'package:ws54_flutter_speedrun7/service/utilites.dart';
import 'package:ws54_flutter_speedrun7/widget/text_button.dart';

import '../constant/style_guide.dart';
import '../widget/custom_text.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserData userData = UserData("", "", "", "", "");
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  bool accountValid = true;
  bool passwordValid = true;
  bool usernameValid = true;
  bool birthdayValid = true;
  @override
  void initState() {
    super.initState();
    getCurrentUserData();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  Future<void> getCurrentUserData() async {
    UserData data = await UserDAO.getUesrDataByUserID(widget.userID);
    userData = data;
    setState(() {
      account_controller.text = data.account;
      password_controller.text = data.password;
      username_controller.text = data.username;
      birthday_controller.text = data.birthday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          customText(AppColor.black, "使用者名稱", 25, true),
          const SizedBox(
            height: 20,
          ),
          usernameTextForm(),
          const SizedBox(
            height: 20,
          ),
          customText(AppColor.black, "生日", 25, true),
          const SizedBox(
            height: 20,
          ),
          birthdeayTextForm(),
          const SizedBox(
            height: 20,
          ),
          submitButton()
        ]),
      ),
    );
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        username_controller.text,
        account_controller.text,
        password_controller.text,
        birthday_controller.text);
  }

  Widget submitButton() {
    return customTextButton(AppColor.black, "編輯完成", 30, () async {
      if (accountValid && passwordValid && usernameValid && birthdayValid) {
        await UserDAO.updateUserData(packUserData());
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      } else {
        Utilites.showSnackBar(context, "檢查一下老哥");
      }
    });
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

  Widget birthdeayTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: birthday_controller,
        readOnly: true,
        onTap: () async {
          DateTime? _picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2026));

          if (_picked != null) {
            birthdayValid = true;
            setState(() {
              birthday_controller.text = _picked.toString().split(" ")[0];
            });
          } else {
            birthdayValid = false;
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            birthdayValid = false;
            return "pls enter somethibg bro";
          } else {
            birthdayValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "YYYY-MM-DD",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: username_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            usernameValid = false;
            return "pls enter somethibg bro";
          } else {
            usernameValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  Widget topBar() {
    return AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "編輯資料",
          style: TextStyle(color: AppColor.black),
        ),
        backgroundColor: AppColor.white);
  }
}
