import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacher_page.dart';
import 'auth_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const AuthPage();
    } else {
      return FutureBuilder<String>(
        future: getUserRole(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String userRole = snapshot.data ?? "Студент";
            if (userRole == "Преподаватель") {
              return const TeacherPage();
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Домашняя страница - $userRole'),
                ),
                body: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Добро пожаловать на домашнюю страницу!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      );
    }
  }

  Future<String> getUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        String userRole = userDoc.get('role');
        return userRole;
      } else {
        return "Студент";
      }
    } catch (e) {
      print('Error getting user role: $e');
      return "Студент";
    }
  }
}
