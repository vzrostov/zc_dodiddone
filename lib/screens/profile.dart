import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import '../theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  User? _user;
  String? _displayName;
  String? _photoURL;

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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoURL != null
                      ? NetworkImage(_photoURL!)
                      : const AssetImage('lib/assets/images/00.png'),
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

// import 'package:flutter/material.dart';
// import 'package:zc_dodiddone/theme/theme.dart';
// import '../pages/login_page.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool isEmailVerified = false; // Флаг для проверки подтверждения почты
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomCenter,
//             colors: [
//               DoDidDoneTheme.lightTheme.colorScheme.secondary,
//               DoDidDoneTheme.lightTheme.colorScheme.primary,
//             ],
//             stops: const [0.1, 0.9], // Основной цвет занимает 90%
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center( // Добавляем Center для центрирования контента
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center, // Центрируем по вертикали
//               children: [
//                 // Аватар
//                 const CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage(
//                       'lib/assets/images/00.png'), // Замените на реальный путь к аватару
//                 ),
//                 const SizedBox(height: 20),
//                 // Почта
//                 const Text(
//                   'example@email.com', // Замените на реальную почту пользователя
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 // Кнопка подтверждения почты (отображается, если почта не подтверждена)
//                 if (!isEmailVerified)
//                   ElevatedButton(
//                     onPressed: () {
//                       // Обработка отправки запроса подтверждения почты
//                       // Например, можно показать диалог с сообщением о том, что письмо отправлено
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Подтверждение почты'),
//                           content: const Text(
//                               'Письмо с подтверждением отправлено на ваш адрес.'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('OK'),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     child: const Text('Подтвердить почту'),
//                   ),
//                 const SizedBox(height: 20),
//                 // Кнопка выхода из профиля
//                 ElevatedButton(
//                   onPressed: () {
//                     // Обработка выхода из профиля
//                     // Например, можно перейти на страницу входа
//                     Navigator.pushReplacement(context,
//                         MaterialPageRoute(builder: (context) {
//                       return const LoginPage();
//                     }));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red, // Красный цвет для кнопки выхода
//                   ),
//                   child: const Text('Выйти'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
