import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final CollectionReference<Map<String, dynamic>> _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _tasksCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final tasks = snapshot.data!.docs.map((doc) {
            return Task.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                task: tasks[index],
                onCompletedChanged: (completed) {
                  _updateTaskCompletion(tasks[index].id, completed);
                }, //title: '', description: '', deadline: null,
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
        DateTime? selectedDeadline;

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
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((pickedTime) {
                          if (pickedTime != null) {
                            setState(() {
                              selectedDeadline = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        });
                      }
                    });
                  },
                  child: Text(
                    selectedDeadline != null
                        ? 'Выбранный дедлайн: ${DateFormat('dd.MM.yyyy HH:mm').format(selectedDeadline!)}'
                        : 'Выбрать дедлайн',
                  ),
                ),
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
                DateTime deadline = selectedDeadline ?? DateTime.now();

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

  // Функция для добавления новой задачи в Firestore
  Future<void> _addTask(String title, String description, DateTime deadline) async {
    await _tasksCollection.add({
      'title': title,
      'description': description,
      'deadline': Timestamp.fromDate(deadline),
      'completed': false,
    });
  }

  // Функция для обновления статуса завершения задачи
  Future<void> _updateTaskCompletion(String taskId, bool completed) async {
    await _tasksCollection.doc(taskId).update({'completed': completed});
  }
}
