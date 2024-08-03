import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zc_dodiddone/screens/all_tasks.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key, this.title, this.description, this.deadline, this.taskId});

  final String? title;
  final String? description;
  final DateTime? deadline; // Переменная для хранения выбранной даты
  final String? taskId;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  // Создаем контроллеры для полей ввода
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline; // Переменная для хранения выбранной даты
  String? _taskId;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _descriptionController.text = widget.description ?? '';
    _deadline = widget.deadline;
    _taskId = widget.taskId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить задачу'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
          // Кнопка для выбора дедлайна
          Row(
            children: [
              const Text('Дедлайн: '),
              if (_deadline != null)
                Text(
                  '${DateFormat('dd.MM.yy HH:mm').format(_deadline ?? DateTime.now())}',
                ),
              IconButton(
                onPressed: () {
                  // Открываем календарь для выбора даты и времени
                  showDatePicker(
                    context: context,
                    initialDate: _deadline ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      // Открываем TimePicker, если дата выбрана
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_deadline ?? DateTime.now()),
                      ).then((pickedTime) {
                        if (pickedTime != null) {
                          setState(() {
                            // Обновляем состояние с помощью setState
                            _deadline = DateTime(
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
                icon: const Icon(Icons.calendar_today),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Закрываем диалог
          },
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () async {
            // Получаем значения из полей ввода
            String title = _titleController.text;
            String description = _descriptionController.text;
            DateTime deadline = _deadline ?? DateTime.now(); // Используем выбранную дату или текущую

            if(widget.taskId != null)
            {
              await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
                'title': title,
                'description': description,
                'deadline': deadline,
              });
            }
            else
            {
              _addTask(title, description, deadline);
            }

            Navigator.of(context).pop(); // Закрываем диалог
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }

  // Функция для добавления задачи в Firestore
  Future<void> _addTask(String title, String description, DateTime deadline) async {
    try {
      // Получаем ссылку на коллекцию "tasks" в Firestore
      final CollectionReference<Task> tasksCollection = FirebaseFirestore.instance.collection('tasks').withConverter<Task>(
        fromFirestore: (snapshot, _) => Task.fromFirestore(snapshot),
        toFirestore: (task, _) => task.toFirestore(),
      );

      // Добавляем новую задачу в коллекцию
      await tasksCollection.add(Task(
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
}
