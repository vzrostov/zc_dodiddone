import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/screens/profile.dart';
import 'package:zc_dodiddone/screens/all_tasks.dart';
import 'package:zc_dodiddone/screens/completed.dart';
import 'package:intl/intl.dart';
import 'package:zc_dodiddone/theme/theme.dart';

import '../screens/today.dart'; // Импортируем intl для форматирования даты

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    TodayPage(),
    CompletedPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для добавления новой задачи
  void _addNewTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Создаем контроллеры для полей ввода
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        DateTime? selectedDeadline; // Переменная для хранения выбранной даты

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
              // Кнопка для выбора дедлайна
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Добавляем отступ сверху
                child: ElevatedButton(
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
                        ? 'Выбранный дедлайн: ${DateFormat('dd.MM.yyyy HH:mm').format(selectedDeadline)}'
                        : 'Выбрать дедлайн',
                  ),
                ),
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
                String title = titleController.text;
                String description = descriptionController.text;
                DateTime deadline = selectedDeadline ?? DateTime.now(); // Используем выбранную дату или текущую

                // Добавляем новую задачу в Firestore
                _addTask(title, description, deadline);

                Navigator.of(context).pop(); // Закрываем диалог
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              DoDidDoneTheme.lightTheme.colorScheme.secondary,
              DoDidDoneTheme.lightTheme.colorScheme.primary,
            ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90%
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
