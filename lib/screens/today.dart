import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/task_item.dart';
import 'all_tasks.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
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
        stream: _tasksCollection
        .where('is_for_today', isEqualTo: true)
        .orderBy('deadline')
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки задач'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;

          if(tasks.isEmpty)
          {
            return const Center(child: Text('Нет задач, время отдыхать!'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final taskData = tasks[index].data();
              final taskId = tasks[index].id;

              return Dismissible(
                key: Key(taskId), // Используем taskId в качестве ключа
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.check_circle, color: Colors.white),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _deleteTask(taskId);
                  } else if (direction == DismissDirection.startToEnd) {
                    
                  }
                },
                child: TaskItem(
                  title: taskData.title != null ? taskData.title : '',
                  description: taskData.description != null ? taskData.description : '',
                  deadline: taskData.deadline,
                  taskId: taskId,
                  onDelete: () {
                    _deleteTask(taskId);
                  },
                  onEdit: () {  }, 
                  toLeft: () {  
                  _tasksCollection
                  .doc (tasks[index].id)
                  .update({'completed': true});
                  }, 
                  toRight: () {  
                  _tasksCollection
                  .doc (tasks[index].id)
                  .update({'is_for_today': true});
                  },
                ),
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
      await _tasksCollection.add(Task(
        title: title, 
        description: description, 
        deadline: deadline,
        completed: false,
        is_for_today: false,
        ));
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