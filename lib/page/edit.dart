import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/service/sharedPref.dart';

import '../constant/style_guide.dart';
import '../service/sql_service.dart';
import '../service/utilites.dart';
import '../widget/custom_text.dart';
import '../widget/text_button.dart';
import 'home.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.data});

  final PasswordData data;
  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool tag = true;
  bool url = true;
  bool login = true;
  bool password = true;

  bool hasLower = true;
  bool hasUpper = true;
  bool hasSymbol = true;
  bool hasNumber = true;
  int length = 16;
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController custom_controller;
  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController(text: widget.data.tag);
    url_controller = TextEditingController(text: widget.data.url);
    login_controller = TextEditingController(text: widget.data.login);
    password_controller = TextEditingController(text: widget.data.password);
    custom_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    custom_controller.dispose();
    super.dispose();
  }

  PasswordData packPasswordData() {
    return PasswordData(
        widget.data.id,
        widget.data.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        widget.data.isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            customText(AppColor.black, "tag", 25, true),
            const SizedBox(height: 20),
            tagTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "url", 25, true),
            const SizedBox(height: 20),
            urlTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "login", 25, true),
            const SizedBox(height: 20),
            loginTextForm(),
            const SizedBox(height: 20),
            customText(AppColor.black, "password", 25, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            favButton(),
            const SizedBox(height: 20),
            randomPasswordSettingButton(context),
            const SizedBox(height: 20),
            submitCreateButton()
          ]),
        ),
      ),
    );
  }

  Widget randomPasswordSettingButton(BuildContext context) {
    return customTextButton(AppColor.black, "random setting", 30, () async {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("random password setting"),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    controller: custom_controller,
                    decoration: const InputDecoration(hintText: "ex:cuboo"),
                  ),
                  CheckboxListTile(
                      title: const Text("包含小寫字母"),
                      value: (hasLower),
                      onChanged: (value) =>
                          setState(() => hasLower = !hasLower)),
                  CheckboxListTile(
                      title: const Text("包含大寫字母"),
                      value: (hasUpper),
                      onChanged: (value) =>
                          setState(() => hasUpper = !hasUpper)),
                  CheckboxListTile(
                      title: const Text("包含符號"),
                      value: (hasSymbol),
                      onChanged: (value) =>
                          setState(() => hasSymbol = !hasSymbol)),
                  CheckboxListTile(
                      title: const Text("包含數字"),
                      value: (hasNumber),
                      onChanged: (value) =>
                          setState(() => hasNumber = !hasNumber)),
                  Row(
                    children: [
                      Slider(
                          min: 1,
                          max: 20,
                          divisions: 19,
                          value: (length.toDouble()),
                          onChanged: (value) =>
                              setState(() => length = value.toInt())),
                      Text(length.toString())
                    ],
                  )
                ]),
              );
            });
          });
    });
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: tag_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            tag = false;
            return "pls enter somethibg bro";
          } else {
            tag = true;
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "tag",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: url_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            url = false;
            return "pls enter somethibg bro";
          } else {
            url = true;
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "url",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: login_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            login = false;
            return "pls enter somethibg bro";
          } else {
            login = true;
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: "login",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: password_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            password = false;
            return "pls enter somethibg bro";
          } else {
            password = true;
            return null;
          }
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.casino),
            onPressed: () => setState(() {
              password_controller.text = Utilites.randomPassowrd(
                  hasLower,
                  hasUpper,
                  hasNumber,
                  hasSymbol,
                  length,
                  custom_controller.text);
            }),
          ),
          hintText: "password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
        ),
      ),
    );
  }

  Widget submitCreateButton() {
    return customTextButton(AppColor.black, "編輯", 30, () async {
      if (tag && url && login && password) {
        PasswordData passwordData = packPasswordData();
        await PasswordDAO.addPasswordData(passwordData);
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.data.userID)));
        }
      } else {
        if (mounted) {
          Utilites.showSnackBar(context, "檢查一下吧");
        }
      }
    });
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(color: AppColor.red, width: 2.0),
            backgroundColor:
                widget.data.isFav == 0 ? AppColor.white : AppColor.red,
            iconColor: widget.data.isFav == 0 ? AppColor.red : AppColor.white),
        onPressed: () => setState(() {
              widget.data.isFav = widget.data.isFav == 0 ? 1 : 0;
            }),
        child: const Icon(Icons.favorite));
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
          "編輯您的密碼",
          style: TextStyle(color: AppColor.black),
        ),
        backgroundColor: AppColor.white);
  }
}
