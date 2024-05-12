import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'menu_book_page.dart';
import 'gamepad_page.dart';
import 'lc_teacher.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  late String userRole = ''; // Инициализация с начальным значением

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userRole = userDoc.get('role') ?? 'Студент';
          });
        }
      }
    } catch (e) {
      print('Error getting user role: $e');
      setState(() {
        userRole = 'Студент';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userRole.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            if (userRole == 'Преподаватель') ...[
              const TeacherPage(),
              const HomePage(),
              const MenuBookPage()
            ],
            if (userRole != 'Преподаватель') ...[
              const GamepadPage(),
              const HomePage(),
              const MenuBookPage(),
            ],
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.menu_book_rounded),
            ),
            Tab(
              icon: Icon(Icons.gamepad),
            ),
          ],
        ),
      ),
    );
  }
}
