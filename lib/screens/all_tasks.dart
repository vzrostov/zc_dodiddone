import 'package:flutter/material.dart';
import '../widgets/task_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);
  @override
  State<TasksPage> createState() => _TasksPageState();
}
class _TasksPageState extends State<TasksPage> {
  final List<String> _tasks = [
    'Купить продукты',
    'Записаться на прием к врачу',
    'Позвонить маме',
    'Сделать уборку',
    'Прочитать книгу',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          title: _tasks[index],
          description: 'Описание задачи',
          deadline: DateTime.now(),
        );
      },
    );
  }
}