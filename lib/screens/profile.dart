import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import '../theme/theme.dart';
import 'package:zc_dodiddone/utils/image_picker.dart'; // Импортируем ImagePickerUtil
import 'dart:io'; // Импортируем File для работы с изображениями
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _user;
  String? _displayName;
  String? _photoURL;
  Uint8List? _selectedImageBytes; // Переменная для хранения выбранного изображения
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil(); // Создаем экземпляр ImagePickerUtil
  bool _showSaveButton = false; // Флаг для отображения кнопки "Сохранить"

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _displayName = _user!.displayName;
      _photoURL = _user!.photoURL;
    }
    setState(() {});
  }

  // Функция для сохранения аватара в Firebase
  Future<void> _saveAvatar() async {
    if (_selectedImageBytes != null) {
      try {
        // Загружаем изображение в Firebase Storage
        final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('user_avatars/${_user!.uid}');
        await ref.putData(_selectedImageBytes!);

        // Получаем URL загруженного изображения
        final String downloadURL = await ref.getDownloadURL();

        // Обновляем photoURL пользователя в Firebase Auth
        await _user!.updateProfile(photoURL: downloadURL); // Use updateProfile instead of updatePhotoURL

        // Обновляем _photoURL для отображения в UI
        setState(() {
          _photoURL = downloadURL;
          _selectedImageBytes = null; // Сбрасываем _selectedImage после сохранения
          _showSaveButton = false; // Скрываем кнопку "Сохранить"
        });
      } catch (e) {
        print('Ошибка сохранения аватара: $e');
        // Обработайте ошибку, например, покажите сообщение пользователю
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _photoURL != null
                          ? NetworkImage(_photoURL!)
                          : const AssetImage('lib/assets/images/00.png'),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: () async {
                          // Вызываем ImagePickerUtil для выбора изображения
                          final Uint8List? imageBytes =
                              await _imagePickerUtil.pickImageFromGallery();
                          if (imageBytes != null) {
                            setState(() {
                              _selectedImageBytes = imageBytes;
                              _showSaveButton = true; // Показывать кнопку "Сохранить"
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_camera),
                      ),
                    ),
                  ],
                ),
                if (_user != null && !_user!.emailVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () async {
                          await _authService.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Письмо с подтверждением отправлено. Проверьте свою почту.',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Подтверждение почты',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _displayName ?? 'Имя пользователя',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _user?.email ?? 'Почта',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            if (_showSaveButton) // Отображаем кнопку "Сохранить", если _showSaveButton == true
              ElevatedButton(
                onPressed: _saveAvatar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Сохранить аватар'),
              ),
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
