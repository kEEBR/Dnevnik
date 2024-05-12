import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'subject_details_page.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница преподавателя'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              showAddSubjectDialog(context);
            },
          ),
        ],
      ),
      // Заменяем ListView.builder на StreamBuilder
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Subjects')
            .where('createdByUserID',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Ошибка: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Преобразование документов из snapshot в список предметов
          final subjectsList = snapshot.data?.docs.map((doc) {
                return Subject(
                  id: doc.id,
                  name: doc['name'],
                  group: doc['group'],
                  assessmentType: doc['type'],
                );
              }).toList() ??
              [];

          // Использование GridView.builder для отображения предметов
          return ListView.builder(
            itemCount: subjectsList.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data?.docs[index];
              final Subject subject = Subject(
                id: doc?.id ?? '',
                name: doc?['name'],
                group: doc?['group'],
                assessmentType: doc?['type'],
              );
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  title: Text(subject.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(subject.group),
                  onTap: () {
                    // Переход на страницу деталей предмета
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SubjectDetailsPage(subject: subject),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showAddSubjectDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String subjectName = '';
    String subjectGroup = '';
    String assessmentType = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить предмет'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Название предмета'),
                  validator: (value) {
                    return value!.isEmpty ? 'Введите название предмета' : null;
                  },
                  onSaved: (value) {
                    subjectName = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Группа'),
                  validator: (value) {
                    return value!.isEmpty ? 'Введите группу' : null;
                  },
                  onSaved: (value) {
                    subjectGroup = value!;
                  },
                ),
                DropdownButtonFormField(
                  value: assessmentType.isEmpty ? null : assessmentType,
                  items: ['Зачет', 'Экзамен']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  hint: const Text('Тип сдачи'),
                  onChanged: (value) {
                    assessmentType = value as String;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // Здесь вы можете вызвать логику для сохранения данных предмета в Firestore
                  addSubjectToFirestore(
                      subjectName, subjectGroup, assessmentType);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addSubjectToFirestore(
      String name, String group, String type) async {
    try {
      final auth.User? firebaseUser = FirebaseAuth.instance.currentUser;
      final String teacherId = firebaseUser?.uid ?? '';

      CollectionReference subjectsRef =
          FirebaseFirestore.instance.collection('Subjects');
      await subjectsRef.add({
        'name': name,
        'group': group,
        'type': type,
        'createdByUserID': teacherId,
        // Можно добавить дополнительные поля, если требуется
      });
      // После добавления, обновляем UI
      setState(() {
        // Обновите ваш список предметов здесь, если вам нужно отобразить его в UI
        // Например, добавление нового предмета в список
      });
    } catch (e) {
      print('Ошибка при добавлении предмета: $e');
    }
  }
}

// Виджет для модального окна добавления студента
class AddStudentDialog extends StatelessWidget {
  const AddStudentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь вы должны создать форму для ввода email и обработчик для кнопки "Отправить приглашение"
    return Dialog(
      child: Column(
        children: [
          const TextField(
              // Контроллер для управления вводом email
              ),
          ElevatedButton(
            child: const Text('Отправить приглашение'),
            onPressed: () {
              // Здесь будет логика отправки приглашения и обновления таблицы
            },
          ),
        ],
      ),
    );
  }
}

class Subject {
  String id;
  String name;
  String group;
  String assessmentType;

  Subject({
    required this.id,
    required this.name,
    required this.group,
    required this.assessmentType,
  });

  // ... другие методы и свойства класса ...
}
