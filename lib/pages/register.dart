import 'package:AniClock/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  void register() async {
    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Invalid Input"),
                content:
                    const Text("Some fields are missing, please try again."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text("Ok")),
                ]);
          });
      return;
    }
    String emailAddress = emailController.text;
    String password = passwordController.text;
    String username = usernameController.text;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      final User user = credential.user!;
      user.updateDisplayName(username);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Success"),
                content: const Text("Account successfully created"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext buildContext) =>
                                    const BaseHomePage()),
                            (route) => false);
                      },
                      child: const Text("Ok")),
                ]);
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Invalid Input"),
                  content: const Text(
                      "The password provided is too weak. Please try again."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text("Ok")),
                  ]);
            });
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Invalid Input"),
                  content:
                      const Text("The account already exists for that email."),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text("Ok")),
                  ]);
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register an account"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.08, 0, width * 0.08, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextField(
                    maxLines: 1,
                    controller: usernameController,
                    decoration: const InputDecoration(hintText: "Username"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextField(
                    maxLines: 1,
                    controller: emailController,
                    decoration:
                        const InputDecoration(hintText: "Email Address"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextField(
                    maxLines: 1,
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    register();
                  },
                  child: const Text("Login"),
                )
              ],
            ),
          ),
        ));
  }
}
