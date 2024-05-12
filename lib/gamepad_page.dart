import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_page.dart';

class GamepadPage extends StatelessWidget {
  const GamepadPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      return userData.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.74, 10.23, 18.07, 15.74),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text("Ошибка загрузки данных");
                }
                if (!snapshot.hasData) {
                  return const Text("Данные пользователя отсутствуют");
                }
                var userData = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          child: const Icon(Icons.menu, size: 30),
                          onTap: () {},
                        ),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.notifications, size: 30),
                              ),
                            ),
                            Image.asset('assets/images/profile.jpg'),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Личный кабинет',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.03,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AuthPage()),
                              );
                            } catch (e) {
                              print('Ошибка при выходе из аккаунта: $e');
                            }
                          },
                          child: const Text('Выйти'),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text('Студента ',
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0.03,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 180,
                          height: 116,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(255, 73, 94, 202),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(90, 0, 0, 0),
                                  blurRadius: 4,
                                  offset: Offset(0, 4)),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 22),
                                  ),
                                  Text(
                                    '300',
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    ' Очков',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Набери 500 очков и',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'получи новую рамку',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 116,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(90, 0, 0, 0),
                                  blurRadius: 4,
                                  offset: Offset(0, 4)),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                              ),
                              Text(
                                'РЕДАКТИРОВАТЬ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 73, 94, 202)),
                              ),
                              Text(
                                'ПРОФИЛЬ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 73, 94, 202)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Личные данные',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 180,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 80, top: 25),
                            child: Column(
                              children: [
                                const Text('Имя',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(userData['firstname'] ?? 'Недоступно',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 80, top: 25),
                            child: Column(
                              children: [
                                const Text('Фамилия',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(userData['lastname'] ?? 'Недоступно',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 180,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 50, top: 25),
                            child: Column(
                              children: [
                                const Text('Студ. билет',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(userData['studentId'] ?? 'Недоступно',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 80, top: 25),
                            child: Column(
                              children: [
                                const Text('Группа',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(userData['group'] ?? 'Недоступно',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Последние новости',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('news')
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Что-то пошло не так');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('Новостей пока нет');
                        }

                        var news = snapshot.data!.docs.first.data()
                            as Map<String, dynamic>;
                        return Container(
                          height: 100,
                          width: 400,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment(0.8, 1),
                                colors: <Color>[
                                  Color.fromARGB(255, 84, 138, 216),
                                  Color.fromARGB(255, 138, 75, 211),
                                ]),
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/news.png',
                                width: 80,
                                height: 80,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        news['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        news['text'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
