import 'package:AniClock/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLogin = false;

  Future<void> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? logined = prefs.getBool('isLogin');
    if (logined == null) {
      await prefs.setBool("isLogin", false);
    }
    setState(() {
      isLogin = prefs.getBool('isLogin')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLogin
            ? const Center(child: Text("isLogin: true"))
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                          "In order to proceed, you must be logged in first."),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext buildContext) =>
                                        const LoginPage()));
                          },
                          child: const Text("Login"))
                    ]),
              ));
  }
}
