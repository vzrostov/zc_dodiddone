import 'package:flutter/material.dart';
import 'package:zc_dodiddone/widgets/task_item.dart';
import '../models/task.dart'; // Import the Task model

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = []; // List of Task objects

  // Function to add a new task
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Get values from input fields
                String title = titleController.text;
                String description = descriptionController.text;
                // Parse the deadline from the deadlineController
                DateTime deadline = DateTime.parse(deadlineController.text);

                // Add a new Task object to the list
                setState(() {
                  _tasks.add(Task(
                    id: '', // You'll need to generate a unique ID here
                    title: title,
                    description: description,
                    deadline: deadline,
                  ));
                });

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: _tasks[index], // Pass the Task object
            onCompletedChanged: (completed) {
              // Handle task completion change
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
