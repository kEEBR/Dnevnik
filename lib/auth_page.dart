// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'main_tabs.dart';
import 'registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AcademIQ Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Авторизация',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(73, 94, 202, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color.fromRGBO(73, 94, 202, 1)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(73, 94, 202, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color.fromRGBO(73, 94, 202, 1)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  print('User logged in: ${userCredential.user?.uid}');

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainTabs()),
                  );
                } on FirebaseAuthException catch (e) {
                  print('Failed to log in: $e');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Ошибка'),
                        content: const Text('Неверный email или пароль'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 54),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFF8A4BD3),
                  ),
                ),
                shadowColor: const Color(0xFF8A4BD3),
                elevation: 6,
              ),
              child: const Text('Войти'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Нет аккаунта? '),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: const Text(
                    'Зарегистрироваться',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
