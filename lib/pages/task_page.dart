import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/all_tasks.dart';
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

          if (tasks.isEmpty) {
            return const Center(child: Text('Нет задач, время отдыхать!'));
          }

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


// import 'package:flutter/material.dart';
// import 'package:zc_dodiddone/widgets/task_item.dart';

// // Класс для страницы со списком задач
// class TasksPage extends StatefulWidget {
//   const TasksPage({super.key});

//   @override
//   State<TasksPage> createState() => _TasksPageState();
// }

// class _TasksPageState extends State<TasksPage> {
//   final List<TaskItem> _tasks = []; // Список задач

//   // Функция для добавления новой задачи
//   void _addNewTask() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // Создаем контроллеры для полей ввода
//         final TextEditingController titleController = TextEditingController();
//         final TextEditingController descriptionController =
//             TextEditingController();
//         final TextEditingController deadlineController =
//             TextEditingController();

//         return AlertDialog(
//           title: const Text('Добавить задачу'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: 'Название'),
//               ),
//               TextField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(labelText: 'Описание'),
//               ),
//               TextField(
//                 controller: deadlineController,
//                 decoration: const InputDecoration(labelText: 'Дедлайн'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Закрываем диалог
//               },
//               child: const Text('Отмена'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Получаем значения из полей ввода
//                 String title = titleController.text;
//                 String description = descriptionController.text;
//                 DateTime deadline = DateTime.now(); // Заменяем на получение даты из deadlineController

//                 // Добавляем новую задачу в список
//                 setState(() {
//                   _tasks.add(TaskItem(
//                     title: title,
//                     description: description,
//                     deadline: deadline,
//                     taskId: 'task${_tasks.length + 1}', // Generate taskId
//                     onDelete: () {}, // Add onDelete callback
//                   ));
//                 });

//                 Navigator.of(context).pop(); // Закрываем диалог
//               },
//               child: const Text('Добавить'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Задачи'),
//       ),
//       body: ListView.builder(
//         itemCount: _tasks.length,
//         itemBuilder: (context, index) {
//           return _tasks[index];
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addNewTask,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }