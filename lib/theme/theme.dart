import 'package:flutter/material.dart';

class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9f7bf6), // Primary color
      primary: const Color(0xFF9f7bf6), // Primary color
      secondary: const Color(0xFF4ceb8b), // Secondary color
    ),
    useMaterial3: true,
    // Добавляем стиль для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF4ceb8b)
        ), // Цвет фона кнопок
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white), // Текст кнопок белый
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF9f7bf6), // Цвет выбранной иконки
      unselectedItemColor:
          const Color(0xFF4ceb8b).withOpacity(0.5), // Цвет невыбранной иконки
      backgroundColor: Colors.transparent, // Прозрачный фон
      // Убираем тень
    ),
  );
}