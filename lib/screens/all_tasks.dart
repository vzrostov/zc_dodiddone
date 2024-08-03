import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/task_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Task> _tasksCollection =
      FirebaseFirestore.instance.collection('tasks').withConverter<Task>(
    fromFirestore: (snapshot, _) => Task.fromFirestore(snapshot),
    toFirestore: (task, _) => task.toFirestore(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
      ),
      body: StreamBuilder<QuerySnapshot<Task>>(
        stream: _tasksCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки задач'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final taskData = tasks[index].data();
              final taskId = tasks[index].id;

              return TaskItem(
                title: taskData.title != null ? taskData.title : '',
                description: taskData.description != null ? taskData.description : '',
                deadline: taskData.deadline,
                taskId: taskId,
                onDelete: () {
                  _deleteTask(taskId);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewTask();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Функция для добавления новой задачи
  void _addNewTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        final TextEditingController deadlineController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Добавить задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
              TextField(
                controller: deadlineController,
                decoration: const InputDecoration(labelText: 'Дедлайн'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                DateTime deadline = DateTime.now(); // Заменяем на получение даты из deadlineController

                _addTask(title, description, deadline);
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  // Функция для добавления задачи в Firestore
  Future<void> _addTask(String title, String description, DateTime deadline) async {
    try {
      await _tasksCollection.add(Task(title: title, description: description, deadline: deadline));
    } catch (e) {
      print('Ошибка добавления задачи: $e');
    }
  }

  // Функция для удаления задачи из Firestore
  Future<void> _deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      print('Ошибка удаления задачи: $e');
    }
  }
}

class Task {
  final String title;
  final String description;
  final DateTime deadline;

  Task({required this.title, required this.description, required this.deadline});

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'deadline': Timestamp.fromDate(deadline),
    };
  }

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Task(
      title: data['title'],
      description: data['description'],
      deadline: (data['deadline'] as Timestamp).toDate(),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../widgets/task_item.dart';

// class TasksPage extends StatefulWidget {
//   const TasksPage({super.key});
//   @override
//   State<TasksPage> createState() => _TasksPageState();
// }
// class _TasksPageState extends State<TasksPage> {
//   final List<String> _tasks = [
//     'Купить продукты',
//     'Записаться на прием к врачу',
//     'Позвонить маме',
//     'Сделать уборку',
//     'Прочитать книгу',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _tasks.length,
//       itemBuilder: (context, index) {
//         return TaskItem(
//           title: _tasks[index],
//           description: 'Описание задачи',
//           deadline: DateTime.now(),
//         );
//       },
//     );
//   }
// }