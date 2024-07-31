import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Объект для работы с аутентификацией Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получение текущего пользователя
  User? get user => _auth.currentUser;

  // Метод для входа с помощью email и пароля
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Вход в Firebase с помощью email и пароля
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок аутентификации
      print('Ошибка входа: ${e.code}');
      return null;
    }
  }

  // Метод для регистрации с помощью email и пароля
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Регистрация в Firebase с помощью email и пароля
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок аутентификации
      print('Ошибка регистрации: ${e.code}');
      return null;
    }
  }

  // Метод для отправки запроса подтверждения почты
  Future<void> sendEmailVerification() async {
    // Получение текущего пользователя
    User? user = _auth.currentUser;

    // Проверка, авторизован ли пользователь
    if (user != null) {
      // Отправка запроса подтверждения почты
      await user.sendEmailVerification();
    }
  }
}
