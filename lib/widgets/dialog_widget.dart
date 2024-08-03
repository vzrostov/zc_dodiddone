import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zc_dodiddone/screens/all_tasks.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key, this.title, this.description, this.deadline});

  final String? title;
  final String? description;
  final DateTime? deadline; // Переменная для хранения выбранной даты

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {

  // Создаем контроллеры для полей ввода
  String? title;
  String? description;
  DateTime? _deadline; // Переменная для хранения выбранной даты

  @override
  void initState() {
    super.initState();
    title = widget.title;
    description = widget.description;
    _deadline = widget.deadline;
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить задачу'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => title = value,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            onChanged: (value) => description = value,
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      // Открываем TimePicker, если дата выбрана
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
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
          onPressed: () {
            // Получаем значения из полей ввода
            DateTime deadline = _deadline ?? DateTime.now(); // Используем выбранную дату или текущую

            // Добавляем новую задачу в Firestore
            _addTask(title ?? '', description ?? '', deadline);

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
