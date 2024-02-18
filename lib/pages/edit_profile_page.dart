import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List _list = ["姓名", "系級", "學號", "聯絡電話", "電子郵件"];
  List initList = [];
  late List<TextEditingController> controllers;
  @override
  void initState() {
    super.initState();
    initList.add(widget.user.username ?? '');
    initList.add(widget.user.className ?? '');
    initList.add(widget.user.studentID ?? '');
    initList.add(widget.user.phoneNumber ?? '');
    initList.add(
      widget.user.email.endsWith('@privaterelay.appleid.com')
          ? ''
          : widget.user.email,
    );
    controllers = List.generate(
        _list.length, (index) => TextEditingController(text: initList[index]));
  }

  Future<String>? confirm() async {
    await FirestoreMethods().updateProfile(
      widget.user.uuid,
      {
        "username": controllers[0].text,
        "className": controllers[1].text,
        "studentID": controllers[2].text,
        "phoneNumber": controllers[3].text,
        "email": controllers[4].text,
      },
    );
    Navigator.pop(context, 'success');
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color hintColor = Theme.of(context).hintColor;
    Color primary = Theme.of(context).colorScheme.primary;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: onSecondary),
        title: MediumText(
          color: onSecondary,
          size: Dimensions.height2 * 8,
          text: '編輯個人資料',
        ),
        actions: [
          CupertinoButton(
            child: MediumText(
              color: hintColor,
              size: Dimensions.height2 * 8,
              text: '修改',
            ),
            onPressed: () {
              confirm();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
              child: Container(
                color: appBarColor,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 4,
                  vertical: Dimensions.height5 * 2,
                ),
                child: Column(
                  children: List.generate(
                    _list.length,
                    (index) {
                      return TextField(
                        onSubmitted: (null),
                        controller: controllers[index],
                        style: TextStyle(color: onSecondary),
                        cursorColor: hintColor,
                        decoration: InputDecoration(
                          hintText: _list[index],
                          hintStyle: TextStyle(color: primary),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 7,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryContainer),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height5 * 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width5 * 7,
                      vertical: Dimensions.height5 * 2,
                    ),
                    decoration: BoxDecoration(
                      color: hintColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MediumText(
                      color: onSecondary,
                      size: Dimensions.height2 * 8,
                      text: '修改',
                    ),
                  ),
                  onPressed: () {
                    confirm();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}