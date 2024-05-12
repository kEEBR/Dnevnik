import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedRole = 'Студент';

  final List<String> roles = ['Студент', 'Преподаватель'];

  Future<void> registerUser(String email, String password, String firstname,
      String lastname, String studentId, String group, String role) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User registered: ${userCredential.user?.uid}');
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'studentId': studentId,
        'group': group,
        'role': role,
      });
    } on FirebaseAuthException catch (e) {
      print('Failed to register user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
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
              'Регистрация',
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
            SizedBox(
              width: 300,
              child: TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль ещё раз',
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
            buildTextField(
              controller: firstNameController,
              labelText: 'Имя',
            ),
            const SizedBox(height: 20),
            buildTextField(
              controller: lastNameController,
              labelText: 'Фамилия',
            ),
            const SizedBox(height: 20),
            if (selectedRole == 'Студент') ...[
              buildTextField(
                controller: studentIdController,
                labelText: 'Студенческий билет',
              ),
              const SizedBox(height: 20),
              buildTextField(
                controller: groupController,
                labelText: 'Группа',
              ),
            ] else if (selectedRole == 'Преподаватель') ...[
              buildTextField(
                controller: studentIdController,
                labelText: 'Институт',
              ),
              const SizedBox(height: 20),
              buildTextField(
                controller: groupController,
                labelText: 'Кафедра',
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                items: roles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Роль',
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
              onPressed: () {
                if (passwordController.text == confirmPasswordController.text) {
                  registerUser(
                    emailController.text,
                    passwordController.text,
                    firstNameController.text,
                    lastNameController.text,
                    studentIdController.text,
                    groupController.text,
                    selectedRole,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Ошибка'),
                        content: const Text('Пароли не совпадают'),
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
              child: const Text('Зарегистрироваться'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Уже есть аккаунт? '),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

SizedBox buildTextField({
  required TextEditingController controller,
  required String labelText,
}) {
  return SizedBox(
    width: 300,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(73, 94, 202, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromRGBO(73, 94, 202, 1)),
        ),
      ),
    ),
  );
}
