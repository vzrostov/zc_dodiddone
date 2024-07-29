import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Объект для работы с аутентификацией Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Объект для работы с Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Получение текущего пользователя
  User? get user => _auth.currentUser;

  // Метод для входа с помощью Google
  Future<UserCredential?> signInWithGoogle() async {
    // Получение учетных данных Google
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    // Проверка, успешно ли получены учетные данные
    if (googleSignInAccount != null) {
      // Получение учетных данных Google для аутентификации Firebase
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Создание учетных данных Firebase с помощью Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Вход в Firebase с помощью Google
      return await _auth.signInWithCredential(credential);
    } else {
      // Возврат null, если вход не удался
      return null;
    }
  }

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

  // Метод для выхода из системы
  Future<void> signOut() async {
    // Выход из Firebase
    await _auth.signOut();

    // Выход из Google
    await _googleSignIn.signOut();
  }
}
