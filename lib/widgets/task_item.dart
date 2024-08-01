import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(bool) onCompletedChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время с помощью intl
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(
        task.deadline ?? DateTime.now()); // Use task.deadline

    // Определяем градиент в зависимости от срочности
    Gradient gradient = getGradient(task.deadline ?? DateTime.now()); // Use task.deadline

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Добавляем Container для градиента
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    task.title, // Use task.title
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                // Кнопки "Редактировать" и "Удалить"
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Располагаем кнопки по краям
                  children: [
                    // Кнопка "Редактировать"
                    IconButton(
                      onPressed: () {
                        // Обработка нажатия на кнопку "Редактировать"
                        // Например, можно открыть диалог для редактирования задачи
                        print('Задача редактируется!');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    // Кнопка "Удалить"
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description ?? '', // Use task.description
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Дедлайн: $formattedDeadline',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Функция для получения градиента в зависимости от срочности
  Gradient getGradient(DateTime deadline) {
    Duration timeUntilDeadline = deadline.difference(DateTime.now());

    if (timeUntilDeadline.inDays <= 1) {
      return const LinearGradient(
        colors: [Colors.red, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (timeUntilDeadline.inDays <= 2) {
      return const LinearGradient(
        colors: [Colors.yellow, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Colors.green, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
