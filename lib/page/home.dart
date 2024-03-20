import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun7/page/add.dart';
import 'package:ws54_flutter_speedrun7/page/edit.dart';
import 'package:ws54_flutter_speedrun7/page/user.dart';
import 'package:ws54_flutter_speedrun7/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun7/service/sql_service.dart';
import 'package:ws54_flutter_speedrun7/widget/text_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List passwordList = [];
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController custom_controller;
  late TextEditingController id_controller;
  bool hasFav = false;
  int isFav = 1;

  @override
  void initState() {
    super.initState();
    setAllPassowrdList();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    custom_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    custom_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }

  bool search = false;
  Future<void> setAllPassowrdList() async {
    search = false;
    List<PasswordData> _passwordList =
        await PasswordDAO.getAllPasswordListByUserID(widget.userID);
    setState(() {
      passwordList = _passwordList;
    });
    print("password list item count ${_passwordList.length}");
  }

  Future<void> setPasswordByCondition() async {
    search = true;
    List<PasswordData> _passwordList =
        await PasswordDAO.getAllPasswordListByCondition(
            widget.userID,
            tag_controller.text,
            url_controller.text,
            login_controller.text,
            password_controller.text,
            id_controller.text,
            hasFav,
            isFav);
    setState(() {
      passwordList = _passwordList;
    });
    print("password list by condirion , item count :${_passwordList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPage(userID: widget.userID)))),
      drawer: drawer(),
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [searchArea(), passwordListViewBuilder()]),
        ),
      ),
    );
  }

  Widget searchArea() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: AppColor.black, width: 2.0)),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: Column(children: [
        TextFormField(
          controller: tag_controller,
        ),
        TextFormField(
          controller: url_controller,
        ),
        TextFormField(
          controller: login_controller,
        ),
        TextFormField(
          controller: password_controller,
        ),
        TextFormField(
          controller: id_controller,
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                  title: const Text("包含我的最愛"),
                  value: (hasFav),
                  onChanged: (value) => setState(() {
                        hasFav = !hasFav;
                      })),
            ),
            Expanded(
              child: CheckboxListTile(
                  enabled: hasFav,
                  title: const Text("我的最愛"),
                  value: (isFav == 0 ? false : true),
                  onChanged: (value) => setState(() {
                        isFav = isFav == 0 ? 1 : 0;
                      })),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextButton(AppColor.black, "搜尋", 20, () {
              setPasswordByCondition();
            }),
            customTextButton(AppColor.black, "還原設定", 20, () {
              setState(() {
                tag_controller.text = "";
                url_controller.text = "";
                password_controller.text = "";
                login_controller.text = "";
                id_controller.text = "";
                hasFav = false;
                isFav = 1;
              });
            }),
            customTextButton(AppColor.black, "取消搜尋", 20, () {
              setAllPassowrdList();
            }),
          ],
        )
      ]),
    );
  }

  Widget passwordListViewBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: passwordList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: dataContaienr(passwordList[index]),
          );
        }));
  }

  Widget dataContaienr(PasswordData data) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: AppColor.black, width: 2.0)),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Text(data.tag),
        Text(data.url),
        Text(data.login),
        Text(data.password),
        Text(data.id),
        Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: AppColor.red, width: 2.0),
                    backgroundColor:
                        data.isFav == 0 ? AppColor.white : AppColor.red,
                    iconColor: data.isFav == 0 ? AppColor.red : AppColor.white),
                onPressed: () async {
                  setState(() {
                    data.isFav = data.isFav == 0 ? 1 : 0;
                  });
                  await PasswordDAO.updatePasswordData(data);
                },
                child: const Icon(Icons.favorite)),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: AppColor.green,
                    iconColor: AppColor.white),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPage(data: data)));
                },
                child: const Icon(Icons.edit)),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: AppColor.red,
                    iconColor: AppColor.white),
                onPressed: () async {
                  await PasswordDAO.removePasswordData(data.id);
                  if (search == false) {
                    setAllPassowrdList();
                  } else {
                    setPasswordByCondition();
                  }
                },
                child: const Icon(Icons.delete)),
          ],
        )
      ]),
    );
  }

  Widget drawer() {
    return Drawer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close)),
        ListTile(
          title: const Text("主畫面"),
          leading: const Icon(Icons.home),
          onTap: () => Navigator.of(context).pop(),
        ),
        ListTile(
          title: const Text("帳號設置"),
          leading: const Icon(Icons.settings),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserPage(userID: widget.userID))),
        )
      ]),
    );
  }

  Widget topBar() {
    return AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "主畫面",
          style: TextStyle(color: AppColor.white),
        ),
        backgroundColor: AppColor.black);
  }
}
