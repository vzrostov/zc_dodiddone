// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import '../pages/login_page.dart';
// import '../services/firebase_auth.dart';
// import '../utils/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _authenticationService =
//       AuthService();
//   Uint8List? _selectedImageBytes; // Переменная для хранения выбранного изображения
//   bool _showSaveButton = false; // Флаг для отображения кнопки "Сохранить"
//   final ImagePickerUtil _imagePickerUtil = ImagePickerUtil(); // Создаем экземпляр ImagePickerUtil

//   @override
//   Widget build(BuildContext context) {
//     final user =
//         _authenticationService.user; // Получаем текущего пользователя

//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Аватар
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _selectedImageBytes != null
//                     ? MemoryImage(_selectedImageBytes!) // Используем выбранное изображение, если оно есть
//                     : user?.photoURL != null
//                         ? NetworkImage(user!
//                             .photoURL!) // Используем аватар пользователя, если он есть
//                         : const AssetImage(
//                             'assets/_1.png'), // Иначе используем стандартный аватар
//               ),
//               Positioned(
//                   bottom: -16,
//                   right: -14,
//                   child: IconButton(
//                       onPressed: () {
//                         // Показываем диалог выбора изображения
//                         _showImagePickerDialog(context);
//                       },
//                       icon: Icon(Icons.photo_camera)))
//             ],
//           ),

//           // Кнопка "Сохранить" (отображается, если выбрано новое изображение)
//           if (_showSaveButton)
//             ElevatedButton(
//               onPressed: () async {
//                 // Загрузка изображения в Firebase Storage
//                 if (_selectedImageBytes != null) {
//                   try {
//                     final storageRef = firebase_storage.FirebaseStorage.instance
//                         .ref()
//                         .child('user_avatars/${user!.uid}');
//                     // final uploadTask =
//                     await storageRef.putData(_selectedImageBytes!);
//                     // await uploadTask.whenComplete(() async {
//                     // Получение URL-адреса загруженного изображения
//                     final downloadURL = await storageRef.getDownloadURL();
//                     // Обновление URL-адреса аватара пользователя в Firebase Authentication
//                     await user.updatePhotoURL(downloadURL);
//                     print('object downloadURL');
//                     // Сброс состояния

//                     setState(() {
//                       _selectedImageBytes = null;
//                       _showSaveButton = false;
//                     });
//                     // Вывод сообщения об успешном сохранении
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Аватар сохранен')));
//                     // }
//                     // );
//                   } catch (e) {
//                     // Обработка ошибок при загрузке
//                     print('Ошибка загрузки аватара: $e');
//                     // Вывод сообщения об ошибке пользователю
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Ошибка загрузки: $e')));
//                   }
//                 }
//               },
//               child: const Text('Сохранить'),
//             ),

//           const SizedBox(height: 20),

//           // Почта
//           Text(
//             user?.email ??
//                 'example@email.com', // Отображаем почту пользователя, если она есть
//             style: const TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           if (user != null && !user.emailVerified)
//             const Text(
//                 'Ваш email пока не подтвержден, вы не можете работать с приложением'),
//           const SizedBox(height: 20),

//           // Кнопка подтверждения почты (отображается, если почта не подтверждена)
//           if (user != null && !user.emailVerified)
//             ElevatedButton(
//               onPressed: () async {
//                 // Отправка запроса подтверждения почты
//                 await _authenticationService.sendEmailVerification();
//                 // Показываем диалог с сообщением о том, что письмо отправлено
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Подтверждение почты'),
//                     content: const Text(
//                         'Письмо с подтверждением отправлено на ваш адрес.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage(
//                                     ))),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: const Text('Подтвердить почту'),
//             ),
//           const SizedBox(height: 20),

//           // Кнопка выхода из профиля
//           ElevatedButton(
//             onPressed: () async {
//               // Выход из системы
//               await _authenticationService.signOut();
//               // Переход на страницу входа
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => LoginPage(
//                         )),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red, // Красный цвет для кнопки выхода
//             ),
//             child: const Text('Выйти'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Диалог выбора изображения
//   void _showImagePickerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Выберите изображение'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Из галереи'),
//                 onTap: () async {
//                   // Выбор изображения из галереи
//                   Uint8List? imageBytes =
//                       await _imagePickerUtil.pickImageFromGallery();
//                   if (imageBytes != null) {
//                     setState(() {
//                       _selectedImageBytes = imageBytes;
//                       _showSaveButton = true; // Показываем кнопку "Сохранить"
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Сделать снимок'),
//                 onTap: () async {
//                   // Съемка изображения с камеры
//                   Uint8List? imageBytes = await _imagePickerUtil.pickImageFromCamera();
//                   if (imageBytes != null) {
//                     setState(() {
//                       _selectedImageBytes = imageBytes;
//                       _showSaveButton = true; // Показываем кнопку "Сохранить"
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import '../theme/theme.dart';
import 'package:zc_dodiddone/utils/image_picker.dart'; // Импортируем ImagePickerUtil
import 'dart:io'; // Импортируем File для работы с изображениями
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';

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
  Uint8List?
      _selectedImageBytes; // Переменная для хранения выбранного изображения
  final ImagePickerUtil _imagePickerUtil =
      ImagePickerUtil(); // Создаем экземпляр ImagePickerUtil
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
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_avatars/${_user!.uid}');
        await ref.putData(_selectedImageBytes!);

        // Получаем URL загруженного изображения
        final String downloadURL = await ref.getDownloadURL();

        // Обновляем photoURL пользователя в Firebase Auth
        await _user!.updatePhotoURL(downloadURL);

        // Обновляем _photoURL для отображения в UI
        setState(() {
          _photoURL = downloadURL;
          _selectedImageBytes =
              null; // Сбрасываем _selectedImage после сохранения
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
                    // CircleAvatar(
                    //   radius: 50,
                    //   onBackgroundImageError: (exception, stackTrace) {
                    //     print('Error loading image: $exception');
                    //     },
                    //   backgroundImage:
                    //   _selectedImageBytes != null
                    //     ? MemoryImage(_selectedImageBytes!) // Используем выбранное изображение, если оно есть
                    //     : _user?.photoURL != null
                    //         ?
                    //         NetworkImage(_user!.photoURL!)
                    //         :
                    //         const AssetImage('lib/assets/images/00.png'),
                    // ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImageBytes != null
                          ? MemoryImage(
                              _selectedImageBytes!) // Используем выбранное изображение, если оно есть
                          : _user?.photoURL != null
                              ? CachedNetworkImageProvider(_user!.photoURL!)
                              : const AssetImage('lib/assets/images/00.png')
                                  as ImageProvider,
                      child: _user?.photoURL != null
                          ? CachedNetworkImage(
                              imageUrl: _user!.photoURL!,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            )
                          : null,
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
                              _showSaveButton =
                                  true; // Показывать кнопку "Сохранить"
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_camera),
                      ),
                    ),
                  ],
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
                  backgroundColor:
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Сохранить аватар'),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
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
