
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.completed = false,
  });

  // Фабричный метод для создания объекта Task из документа Firestore
  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      deadline: (data['deadline'] != null) ? (data['deadline'] as Timestamp).toDate() : null,
      completed: data['completed'],
    );
  }

  // Метод для преобразования объекта Task в Map для сохранения в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'completed': completed,
    };
  }
}
