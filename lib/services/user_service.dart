import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../model/user/user_model.dart';
import '../utils/verify_internet_connection.dart';
import '../model/exceptions/internet_exception.dart';
import '../model/exceptions/user_exception.dart';

abstract class UserService {
  Future<void> createOrAuthenticateUser(UserModel user, {bool login = true});
  Stream<FirebaseUser> verifyAuthUser();
  Future<dynamic> signOut();
  Future<FirebaseUser> getCurrentFirebaseUser();
  Future<UserModel> getUserData();
  Future<String> getCurrentUser();
}

class UserServiceImpl implements UserService {
  final _authInstance = FirebaseAuth.instance;
  final _storeInstance = Firestore.instance;
  static String _userId;

  @override
  Future<void> createOrAuthenticateUser(UserModel user,
      {bool login = true}) async {
    //final timeStamp = Timestamp.now();
    AuthResult _authResult;

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
            .document(_authResult.user.uid)
            .setData(user.toMap());
      }
    } on AuthException catch (error) {
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          throw UserException(
              'O e-mail informado é inválido! Por favor, verifique.');

        case 'ERROR_INVALID_PASSWORD':
          throw UserException(
              'A senha informada não está correta! Por favor, verifique.');

        case 'ERROR_EMAIL_NOT_FOUND':
          throw UserException(
              'O e-mail informado não foi encontrado! Por favor, verifique.');

        case 'ERROR_USER_NOT_FOUND':
          throw UserException(
              'O e-mail informado não foi encontrado! Por favor, verifique.');

        case 'ERROR_USER_DISABLED':
          throw UserException(
              'O e-mail informado foi desabilitado! Por favor, entre em contato com o administrador.');

        default:
          throw UserException('Houve um erro na autenticação do usuário!');
      }
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND':
          throw UserException(
              'O e-mail informado não foi encontrado. Por favor, verifique!');

        case 'ERROR_WRONG_PASSWORD':
          throw UserException(
              'A senha informada não está correta. Por favor, verifique!');

        case 'ERROR_WEAK_PASSWORD':
          throw UserException(
              'A senha informada não é adequada. Por favor, informe uma senha contendo letras (minúscula e maiúscula), números e símbolos (#%*!\$)');

        case 'ERROR_INVALID_EMAIL':
          throw UserException(
              'O endereço de e-mail informado não está no formato correto. Por favor, verifique!');

        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw UserException(
              'Já existe um usuário com o e-mail informado. Por favor, verifique!');

        case 'ERROR_USER_DISABLED':
          throw UserException(
              'O e-mail informado foi desabilitado! Por favor, entre em contato com o administrador.');

        case 'ERROR_NETWORK_REQUEST_FAILED':
          throw InternetException(
              'Houve um erro ao tentar se conectar com o servidor. Verifique sua conexão com a internet.');

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
  Stream<FirebaseUser> verifyAuthUser() {
    return _authInstance.onAuthStateChanged;
  }

  @override
  Future<FirebaseUser> getCurrentFirebaseUser() {
    return _authInstance.currentUser();
  }

  @override
  Future<void> signOut() {
    return _authInstance.signOut();
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      final userId = await getCurrentUser();
      final userReference =
          await _storeInstance.collection('users').document(userId).get();
      final userData = UserModel.fromMap(userReference.data);

      return userData;
    } on PlatformException catch (error) {
      print(error.message);
      throw UserException(
          'Houve um erro ao tentar recuperar informações do usuário');
    }
  }

  @override
  Future<String> getCurrentUser() async {
    if (_userId != null) {
      return _userId;
    } else {
      final result = await getCurrentFirebaseUser();
      if (result != null) {
        _userId = result.uid;
      }
      return _userId;
    }
  }
}
