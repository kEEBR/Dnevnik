import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as auth; // Используйте псевдоним 'auth'
import 'teacher_page.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class SubjectDetailsPage extends StatefulWidget {
  final Subject subject;

  const SubjectDetailsPage({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SubjectDetailsPageState createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  void showGradeDialog(BuildContext context, DateTime date, String studentEmail,
      String subjectId, Function(String) onGradeSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите оценку'),
          content: Wrap(
            spacing: 8.0,
            children: <String>['5', '4', '3', '2', 'н']
                .map((grade) => ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onGradeSelected(grade);
                        saveGrade(studentEmail, subjectId, date, grade);
                      },
                      child: Text(grade),
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  void saveGrade(String studentEmail, String subjectId, DateTime date,
      String grade) async {
    DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateWithoutTime);
    final QuerySnapshot existingGrades = await FirebaseFirestore.instance
        .collection('grades')
        .where('studentEmail', isEqualTo: studentEmail)
        .where('subjectId', isEqualTo: subjectId)
        .where('gradeDate', isEqualTo: formattedDate)
        .get();

    // Добавляем оценку только если оценки на эту дату еще нет
    if (existingGrades.docs.isEmpty) {
      // Создаем новый документ в коллекции 'grades'
      await FirebaseFirestore.instance.collection('grades').add({
        'studentEmail': studentEmail,
        'subjectId': subjectId,
        'date': Timestamp.fromDate(date), // Timestamp для полной даты и времени
        'gradeDate': formattedDate, // Строка для уникальной даты оценки
        'value': grade,
      });

      // Обновляем локальное состояние
      setState(() {
        studentGrades[studentEmail] ??= {};
        studentGrades[studentEmail]![dateWithoutTime] = grade;
      });
    } else {
      // Оценка на данную дату уже существует, возможно показать сообщение об ошибке
    }
  }

  final Map<String, Map<DateTime, String>> studentGrades = {};
  void addStudentByEmail(String email, String subjectId) async {
    if (email.isEmpty) {
      // Выводим сообщение об ошибке, если email не введён
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email не может быть пустым!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    final String createdByUserID = firebaseUser?.uid ?? '';

    // Поиск пользователя с данным email в коллекции "Users"
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // Проверяем, есть ли пользователь с таким email
    if (userSnapshot.docs.isEmpty) {
      // Выводим сообщение об ошибке, если пользователь не найден
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Пользователь с таким email не найден!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (userSnapshot.docs.isNotEmpty) {
      final DocumentSnapshot userDoc = userSnapshot.docs.first;
      final User newUser =
          User.fromSnapshot(userDoc.data() as Map<String, dynamic>);

      // Теперь при добавлении студента мы включаем 'subjectIds'
      final DocumentReference studentDocRef =
          FirebaseFirestore.instance.collection('Students').doc(newUser.email);

      // Перед сохранением проверим существует ли уже документ
      final DocumentSnapshot studentDoc = await studentDocRef.get();
      if (studentDoc.exists) {
        // Если документ существует, добавим ID предмета в массив subjectIds
        await studentDocRef.update({
          'subjectIds': FieldValue.arrayUnion([subjectId]),
        });
      } else {
        // Если документа нет, создадим новый и добавим ID предмета в массив subjectIds
        await studentDocRef.set({
          ...newUser.toMap(),
          'createdByUserID':
              createdByUserID, // Добавляем поле 'createdByUserID'
          'subjectIds': [subjectId], // Создаем массив с одним ID предмета
        });
      }

      // Обновляем UI, вызвав fetchStudents
      fetchStudents();
    }
  }

  List<User> students = []; // Список студентов для отображения в таблице

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    final String currentUserId = firebaseUser?.uid ?? '';

    if (currentUserId.isNotEmpty) {
      final QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('subjectIds', arrayContains: widget.subject.id)
          .get();

      final List<User> fetchedStudents = studentSnapshot.docs
          .map((doc) => User.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();

      // Инициализируем временный список для хранения Future'ов загрузки оценок
      List<Future<void>> gradeFetches = [];

      // Заполняем временный список Future'ами вызовов fetchGradesForStudent
      for (var student in fetchedStudents) {
        gradeFetches.add(fetchGradesForStudent(student));
      }

      // Дожидаемся завершения всех Future'ов
      await Future.wait(gradeFetches);

      // Обновляем состояние один раз после загрузки и обработки всех оценок
      setState(() {
        students = fetchedStudents;
      });
    } else {
      // Обрабатываем случай, когда пользователь не вошел в систему
    }
  }

  Future<void> fetchGradesForStudent(User student) async {
    final String subjectId = widget.subject.id;

    final QuerySnapshot gradeSnapshot = await FirebaseFirestore.instance
        .collection('grades')
        .where('studentEmail', isEqualTo: student.email)
        .where('subjectId', isEqualTo: subjectId)
        .get();

    Map<DateTime, String> gradesForStudent = {};
    for (var doc in gradeSnapshot.docs) {
      var gradeData = doc.data() as Map<String, dynamic>;
      String gradeDateStr = gradeData['gradeDate'];
      DateTime gradeDate =
          DateFormat('yyyy-MM-dd').parse(gradeDateStr, true).toUtc();
      String value = gradeData['value'] as String;
      gradesForStudent[gradeDate] = value;
    }

    // Обновляем состояние оценок для каждого студента
    // Это безопасно, так как обновления состояния сливаются в Flutter
    setState(() {
      studentGrades[student.email] = gradesForStudent;
    });
  }

  void fetchGrades() async {
    final String subjectId = widget.subject.id;

    for (var student in students) {
      final QuerySnapshot gradeSnapshot = await FirebaseFirestore.instance
          .collection('grades')
          .where('studentEmail', isEqualTo: student.email)
          .where('subjectId', isEqualTo: subjectId)
          .get();

      Map<DateTime, String> gradesForStudent = {};
      for (var doc in gradeSnapshot.docs) {
        var gradeData = doc.data() as Map<String, dynamic>;
        String gradeDateStr = gradeData['gradeDate'];
        DateTime gradeDate =
            DateFormat('yyyy-MM-dd').parse(gradeDateStr, true).toUtc();
        String value = gradeData['value'] as String;
        gradesForStudent[gradeDate] = value;
      }

      // Добавьте вывод в консоль для отладки
      print('Grades for ${student.email}: $gradesForStudent');

      setState(() {
        studentGrades[student.email] = gradesForStudent;
      });
    }
  }

  void showAddStudentDialog() {
    String email = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить студента'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(hintText: "email студента"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Добавить'),
              onPressed: () {
                addStudentByEmail(email, widget.subject.id);
                Navigator.of(context).pop(); // Закрыть модальное окно
              },
            ),
          ],
        );
      },
    );
  }

  String getMonthNameInNominative(String monthYear) {
    const Map<String, String> monthsNominative = {
      'января': 'Январь',
      'февраля': 'Февраль',
      'марта': 'Март',
      'апреля': 'Апрель',
      'мая': 'Май',
      'июня': 'Июнь',
      'июля': 'Июль',
      'августа': 'Август',
      'сентября': 'Сентябрь',
      'октября': 'Октябрь',
      'ноября': 'Ноябрь',
      'декабря': 'Декабрь',
    };

    final parts = monthYear.split(' ');
    if (parts.length == 2) {
      final monthNominative = monthsNominative[parts[0].toLowerCase()];
      if (monthNominative != null) {
        return '$monthNominative ${parts[1]}';
      }
    }
    return monthYear;
  }

  @override
  Widget build(BuildContext context) {
    // Создаем список дат: сегодня и следующие 30 дней, чтобы иметь возможность прокрутки
    List<DateTime> dates =
        List.generate(30, (index) => DateTime.now().add(Duration(days: index)));

    // Определяем месяц и год первой и последней даты в списке
    String monthYearStart = DateFormat('LLLL y', 'ru').format(dates.first);
    String monthYearEnd = DateFormat('LLLL y', 'ru').format(dates.last);

    monthYearStart = getMonthNameInNominative(monthYearStart);
    monthYearEnd = getMonthNameInNominative(monthYearEnd);

    // Заголовок, который будет обновляться при прокрутке
    String headerTitle = monthYearStart;

    // Если месяцы начальной и конечной даты различаются, обновляем заголовок
    if (monthYearStart != monthYearEnd) {
      headerTitle = '$monthYearStart - $monthYearEnd';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showAddStudentDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              // Статичный столбец для имён студентов
              DataTable(
                columns: const [
                  DataColumn(label: Text('Студент')),
                ],
                rows: students
                    .map(
                      (student) => DataRow(cells: [
                        DataCell(
                            Text('${student.firstname} ${student.lastname}')),
                      ]),
                    )
                    .toList(),
              ),
              const VerticalDivider(width: 2, color: Colors.black),
              // Прокручиваемая часть таблицы с датами
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: dates
                        .map((date) => DataColumn(
                              label:
                                  Text(DateFormat('dd.MM', 'ru').format(date)),
                            ))
                        .toList(),
                    rows: students
                        .map((student) => DataRow(
                              cells: dates.map((date) {
                                // Преобразуем date в формат 'yyyy-MM-dd', чтобы получить оценку
                                DateTime dateWithoutTime =
                                    DateTime(date.year, date.month, date.day);
                                final grade = studentGrades[student.email]
                                    ?[dateWithoutTime];
                                return DataCell(
                                  Container(
                                    color: _getGradeColor(grade),
                                    child: InkWell(
                                      onTap: () {
                                        showGradeDialog(
                                            context,
                                            date,
                                            student.email,
                                            widget.subject.id, (selectedGrade) {
                                          setState(() {
                                            studentGrades[student.email] ??= {};
                                            studentGrades[student.email]![
                                                date] = selectedGrade;
                                          });
                                        });
                                      },
                                      child: Center(child: Text(grade ?? '')),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String? grade) {
    switch (grade) {
      case '5':
        return Colors.greenAccent;
      case '4':
        return Colors.yellow;
      case '3':
        return Colors.orange;
      case '2':
        return Colors.red;
      case 'н':
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }
}

class Grade {
  DateTime date;
  String value;

  Grade({required this.date, required this.value});
}
