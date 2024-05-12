import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String firstname;
  final String lastname;

  User({required this.email, required this.firstname, required this.lastname});

  // Фабричный конструктор для создания объекта User из документа Firestore
  factory User.fromSnapshot(Map<String, dynamic> snapshot) {
    return User(
      email: snapshot['email'] as String,
      firstname: snapshot['firstname'] as String,
      lastname: snapshot['lastname'] as String,
    );
  }

  // Метод для преобразования объекта User в Map, удобный для загрузки данных в Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
