import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../model/user/user_model.dart';
import '../utils/verify_internet_connection.dart';
import '../model/exceptions/internet_exception.dart';
import '../model/exceptions/user_exception.dart';

abstract class UserService {
  Future<void> createOrAuthenticateUser(UserModel user, {bool login = true});
  Stream<User> verifyAuthUser();
  Future<dynamic> signOut();
  User getCurrentFirebaseUser();
  Future<UserModel> getUserData();
  Future<String> getCurrentUser();
}

class UserServiceImpl implements UserService {
  final _authInstance = FirebaseAuth.instance;
  final _storeInstance = FirebaseFirestore.instance;
  static String _userId;

  @override
  Future<void> createOrAuthenticateUser(UserModel user,
      {bool login = true}) async {
    UserCredential _authResult;

    try {
      final isInternetOn = await VerifyInternetConnection.getStatus();
      if (!isInternetOn) {
        throw InternetException(
            'Não há conexão ativa com a internet. Por favor, verifique a sua conexão.');
      }
      if (login) {
        _authResult = await _authInstance.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      } else {
        _authResult = await _authInstance.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );

        await _storeInstance
            .collection('users')
            .doc(_authResult.user.uid)
            .set(user.toMap());
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          throw UserException(
              'O e-mail informado não foi encontrado.\nPor favor, verifique!');
        case 'email-already-exists':
          throw UserException(
              'O e-mail informado já existe.\nPor favor, verifique!');
        case 'wrong-password':
          throw UserException(
              'A senha informada não está correta.\nPor favor, verifique!');
        case 'invalid-password':
          throw UserException(
              'A senha informada não está correta.\nPor favor, verifique!');
        case 'weak-passowrd':
          throw UserException(
              'A senha informada não é adequada.\nPor favor, informe uma senha contendo letras (minúscula e maiúscula), números e símbolos (#%*!\$)');
        case 'invalid-email':
          throw UserException(
              'O endereço de e-mail informado não está no formato correto.\nPor favor, verifique!');

        case 'email-already-in-use':
          throw UserException(
              'Já existe um usuário cadastrado para o e-mail informado.\nPor favor, informe um novo e-mail!');

        case 'user-disabled':
          throw UserException(
              'O e-mail informado foi desabilitado!\nPor favor, entre em contato com o administrador.');

        case 'too-many-requests':
          throw UserException(
              'No momento há muitas requisições.\nPor favor, tente novamente mais tarde!');

        case 'network-request-failed':
          throw InternetException(
              'Houve um erro ao tentar se conectar com o servidor.\nVerifique sua conexão com a internet.');

        default:
          throw UserException('Houve um erro no cadastro do usuário!');
      }
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND':
          throw UserException(
              'O e-mail informado não foi encontrado.\nPor favor, verifique!');

        case 'ERROR_WRONG_PASSWORD':
          throw UserException(
              'A senha informada não está correta.\nPor favor, verifique!');

        case 'ERROR_WEAK_PASSWORD':
          throw UserException(
              'A senha informada não é adequada.\nPor favor, informe uma senha contendo letras (minúscula e maiúscula), números e símbolos (#%*!\$)');

        case 'ERROR_INVALID_EMAIL':
          throw UserException(
              'O endereço de e-mail informado não está no formato correto.\nPor favor, verifique!');

        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw UserException(
              'Já existe um usuário cadastrado para o e-mail informado.\nPor favor, informe um novo e-mail!');

        case 'ERROR_USER_DISABLED':
          throw UserException(
              'O e-mail informado foi desabilitado!\nPor favor, entre em contato com o administrador.');

        case 'ERROR_TOO_MANY_REQUESTS':
          throw UserException(
              'No momento há muitas requisições.\nPor favor, tente novamente mais tarde!');

        case 'ERROR_NETWORK_REQUEST_FAILED':
          throw InternetException(
              'Houve um erro ao tentar se conectar com o servidor.\nVerifique sua conexão com a internet.');

        default:
          throw UserException('Houve um erro no cadastro do usuário!');
      }
    } on InternetException catch (error) {
      throw (error);
    } on Exception catch (error) {
      throw Exception(
          'Houve erro ao tentar processar o usuario' + error.toString());
    }
  }

  @override
  Stream<User> verifyAuthUser() {
    return _authInstance.authStateChanges();
  }

  @override
  User getCurrentFirebaseUser() {
    return _authInstance.currentUser;
  }

  @override
  Future<void> signOut() {
    _userId = null;
    return _authInstance.signOut();
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      final userId = await getCurrentUser();
      final userReference =
          await _storeInstance.collection('users').doc(userId).get();
      final userData = UserModel.fromMap(userId, userReference.data());

      return userData;
    } on PlatformException catch (_) {
      throw UserException(
          'Houve um erro ao tentar recuperar informações do usuário');
    }
  }

  @override
  Future<String> getCurrentUser() async {
    if (_userId != null) {
      return _userId;
    } else {
      final result = getCurrentFirebaseUser();
      if (result != null) {
        _userId = result.uid;
      }
      return _userId;
    }
  }
}
