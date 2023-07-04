import 'package:flutter/material.dart';
import 'homepage.dart';
void main() {
  runApp(const HairStylist());
}

class HairStylist extends StatelessWidget {
  const HairStylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.74, 10.23, 18.07, 15.74),
            child: Column(
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
                const Text(
                  'Привет, Иван',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.03,
                    color: Colors.black,
                  ),
                ),
                const Row(
                  children: [
                    Text('Это твой ',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 0.03,
                          color: Colors.black,
                        )),
                    Text('личный ',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          letterSpacing: 0.03,
                        )),
                    Text(
                      'кабинет.',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.03,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Text('Чувствуй себя как дома',
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.03,
                      color: Colors.black,
                    )),
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 80, top: 25),
                        child: Column(
                          children: [
                            Text('Имя',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Text('Иван',
                                style: TextStyle(
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 80, top: 25),
                        child: Column(
                          children: [
                            Text('Фамилия',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Text('Иванов',
                                style: TextStyle(
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 50, top: 25),
                        child: Column(
                          children: [
                            Text('Студ. билет',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Text('201343',
                                style: TextStyle(
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 80, top: 25),
                        child: Column(
                          children: [
                            Text('Группа',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              height: 4,
                            ),
                            Text('ПИНЖ-32',
                                style: TextStyle(
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
                Container(
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
                      const Column(
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          Text('Зачётная неделя',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          Text('Уважаемые студенты, спешу сообщить, ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              )),
                          Text('что 2 июня начинается зачётная неделя!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.home_filled,
                            size: 30,
                            color: Color.fromARGB(255, 73, 94, 202),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3.3,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.gamepad,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
