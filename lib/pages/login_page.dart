import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/main_page.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import '../theme/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)

  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Для подтверждения пароля

  final AuthService _authService = AuthService(); // Создаем экземпляр AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: isLogin
                ? [
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                  ]
                : [
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90%
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/00.png', // Замените на правильный путь к файлу
                    height: 60, // Устанавливаем высоту изображения
                  ),
                  const SizedBox(width: 8),
                  // Добавляем текст "zerocoder"
                  Text(
                    'Zerocoder',
                    style: TextStyle(
                      fontSize: 62,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Белый цвет текста
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Добавляем текст "Do"
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Do',
                      style: TextStyle(
                        color: DoDidDoneTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    const TextSpan(
                      text: 'Did',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Done',
                      style: TextStyle(
                        color: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Заголовок
              Text(
                isLogin ? 'Вход' : 'Регистрация',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

                // Поле логина/почты
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Почта',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Некорректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Поле пароля
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Поле "Повторить пароль" (только для регистрации)
                if (!isLogin)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Повторить пароль',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, повторите пароль';
                      }
                      if (value != _passwordController.text) {
                        return 'Пароли не совпадают';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 30),

                // Кнопка "Войти" / "Зарегистрироваться"
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Проверка, валидна ли форма
                      if (isLogin) {
                        // Вход
                        UserCredential? userCredential =
                            await _authService.signInWithEmailAndPassword(
                                _emailController.text, _passwordController.text);
                        if (userCredential != null) {
                          // Успешный вход
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()));
                        } else {
                          // Ошибка входа
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ошибка входа')));
                        }
                      } else {
                        // Регистрация
                        UserCredential? userCredential =
                            await _authService.createUserWithEmailAndPassword(
                                _emailController.text, _passwordController.text);
                        if (userCredential != null) {
                          // Успешная регистрация
                          // Отправка запроса подтверждения почты
                          await _authService.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Регистрация прошла успешно. Проверьте свою почту для подтверждения.')));
                        } else {
                          // Ошибка регистрации
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ошибка регистрации')));
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isLogin
                        ? DoDidDoneTheme.lightTheme.colorScheme.primary
                        : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                ),

              const SizedBox(height: 20),
              
              // Кнопка перехода на другую страницу
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'У меня ещё нет аккаунта...'
                      : 'Уже есть аккаунт...',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
