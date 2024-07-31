import 'package:flutter/material.dart';
import 'package:zc_dodiddone/screens/profile.dart';
import 'package:zc_dodiddone/screens/all_tasks.dart';
import 'package:intl/intl.dart';
import 'package:zc_dodiddone/theme/theme.dart'; // Импортируем intl для форматирования даты

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    Text('Сегодня'),
    ProfilePage(),
    Text('Выполнено'),
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
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Добавляем новую задачу в список (предполагаем, что TasksPage имеет список задач)
                // Нужно передать новую задачу в TasksPage
                // Например, можно использовать Provider или другой механизм передачи данных
                // ...

                Navigator.of(context).pop(); // Закрываем диалог
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
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
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
