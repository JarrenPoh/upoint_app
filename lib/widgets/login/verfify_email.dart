import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/pages/login_page.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  final Uri uri;
  const VerifyEmail({
    super.key,
    required this.email,
    required this.uri,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? resentTimer;
  int resentTime = 60;
  bool isLoading = false;
  bool canResentEmail = false;

  @override
  void initState() {
    super.initState();
    getUserEmailVerify();
  }

  getUserEmailVerify() {
    isEmailVerified = auth.FirebaseAuth.instance.currentUser!.emailVerified;
    print('信箱驗證 $isEmailVerified');
    Send();
  }

  Future Send() async {
    resentTime = 60;
    setState(() {
      isLoading = true;
      canResentEmail = false;
    });

    if (!isEmailVerified) {
      String res = await AuthMethods().sendVerificationEmail();

      if (res == 'success') {
        Get.snackbar(
          "成功",
          '驗證信箱已送出，請查閱',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(
            seconds: 3,
          ),
        );
        timer =
            Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());

        resentTimer = Timer.periodic(Duration(seconds: 1), (_) {
          setState(() {
            resentTime--;
            print('resenttTime$resentTime');
            if (resentTime == 0) {
              canResentEmail = true;
              resentTimer!.cancel();
            }
          });
        });
      } else {
        Get.snackbar(
          "失敗",
          res.toString() + ' ，請回報官方發現問題',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(
            seconds: 4,
          ),
        );
      }
    } else {
      bool exist = false;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) => exist = doc.exists);
      if (!exist) {
        checkEmailVerified();
      } else {}
    }

    setState(() {
      isLoading = false;
    });
  }

  //
  checkEmailVerified() async {
    await auth.FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = auth.FirebaseAuth.instance.currentUser!.emailVerified;
    print('after reload emailVerified $isEmailVerified');

    if (isEmailVerified) {
      resentTimer?.cancel();
      timer?.cancel();
      //上傳用戶註冊資料
      String res = await FirestoreMethods()
          .signUpUser(widget.email, auth.FirebaseAuth.instance.currentUser!);
      if (res == 'success') {
        Get.snackbar(
          "成功",
          '歡迎加入，趕快發一則貼文吧!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(
            seconds: 3,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              uri: widget.uri,
            ),
          ),
          (route) => false,
        );
      } else {
        Get.snackbar(
          "失敗",
          res.toString() + ' ，請回報官方發現問題',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(
            seconds: 4,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    resentTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color hintColor = Theme.of(context).hintColor;
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: MediumText(
          color: onSecondary,
          size: 18,
          text: '信箱驗證',
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('信箱驗證發送至你的信箱，請查閱'),
                const SizedBox(
                  height: 24,
                ),
                CupertinoButton(
                  onPressed: canResentEmail ? Send : () {},
                  child: Container(
                    width: Dimensions.width5 * 20,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: canResentEmail ? hintColor : Colors.grey,
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : MediumText(
                            color: Colors.white,
                            size: 16,
                            text:
                                canResentEmail ? '重新發送' : resentTime.toString(),
                          ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  height: Dimensions.height5 * 14,
                  width: Dimensions.width5 * 14,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: onPrimary,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}