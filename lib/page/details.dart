import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/page/home.dart';
import 'package:ws54_flutter_speedrun7/service/auth.dart';
import 'package:ws54_flutter_speedrun7/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun7/service/sql_service.dart';
import 'package:ws54_flutter_speedrun7/service/utilites.dart';
import 'package:ws54_flutter_speedrun7/widget/text_button.dart';

import '../constant/style_guide.dart';
import '../widget/custom_text.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});

  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool usernameValid = false;
  bool birthdayValid = false;
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: topbar()),
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          customText(AppColor.black, "使用者基本資料", 40, true),
          const SizedBox(
            height: 20,
          ),
          customText(AppColor.black, "名稱", 25, true),
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
          registerButton()
        ]),
      ),
    );
  }

  UserData packUserData() {
    return UserData(Utilites.randomID(), username_controller.text,
        widget.account, widget.password, birthday_controller.text);
  }

  Widget registerButton() {
    return customTextButton(AppColor.black, "開始使用", 30, () async {
      if (birthdayValid && usernameValid) {
        UserData userData = packUserData();
        await Auth.registerAuth(userData);
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: userData.id)));
          Utilites.showSnackBar(context, "歡迎!");
        }
      } else {
        if (mounted) {
          Utilites.showSnackBar(context, "瞎了嗎");
        }
      }
    });
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

  Widget topbar() {
    return AppBar(
      backgroundColor: AppColor.black,
      title: Text("即將完成註冊"),
    );
  }
}
