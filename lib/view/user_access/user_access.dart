import 'package:flutter/material.dart';

import './widgets/form_user_access.dart';
import '../../view_model/user_acess_view_model.dart';
import '../../model/user_model.dart';
import '../../utils/loading_status.dart';
import '../../utils/type_user.dart';

class UserAccessView extends StatefulWidget {
  static const routeName = '/login-view';
  @override
  _UserAccessViewState createState() => _UserAccessViewState();
}

class _UserAccessViewState extends State<UserAccessView> {
  final viewModel = UserAccessViewModel();
  bool _isLogin = true;
  bool _isLoading = false;

  void setLogin(bool value) {
    setState(() {
      _isLogin = value;
    });
  }

  void setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  bool getIsLoading() {
    return _isLoading;
  }

  bool getIsLogin() {
    return _isLogin;
  }

  Future<void> showMessageToUser(String title, String message) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: DialogTheme.of(context).shape,
        title: Text(
          title,
        ),
        content: Text(
          message,
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text(
              'Ok',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processUserRequest(
    String userName,
    String userSurname,
    String userEmail,
    String userPassword,
    TypeOfUser typeOfUser,
  ) async {
    setIsLoading(true);

    UserModel user;

    final titleCreateUser = 'Cadastro de Usuário';

    final messageCreateUserWithSuccess = 'Usuário cadastrado com sucesso!';

    final messageCreateUserWithError =
        'Houve erro ao cadastrar o usuário! Verifique as informações fornecidas.';

    final messageCreateUserWithUndefinedError =
        'Houve erro ao cadastrar o usuário, verifique as informações e tente novamente!';

    final titleAuthenticateUser = 'Autenticação do Usuário';
    final messageLoginUserWithError =
        'Houve erro ao processar a autenticação. Verifique as informações fornecidas!';

    final messageLogiWithUndefinedError =
        'Houve erro ao processar a autenticação, verifique as informações e tente novamente!';
    if (_isLogin) {
      user = UserModel(
        email: userEmail,
        password: userPassword,
      );
      await viewModel.createOrAuthenticateUser(user);
    } else {
      user = UserModel(
        name: userName,
        surName: userSurname,
        email: userEmail,
        password: userPassword,
        typeUser: typeOfUser,
      );

      await viewModel.createOrAuthenticateUser(user, login: false);
    }
    switch (viewModel.loadingStatus) {
      case LoadingStatus.completed:
        setIsLoading(false);
        if (!_isLogin) {
          await showMessageToUser(
            titleCreateUser,
            messageCreateUserWithSuccess,
          );
          setLogin(true);
        }
        break;
      case LoadingStatus.error:
        if (viewModel.userException != null) {
          if (_isLogin) {
            await showMessageToUser(
                titleAuthenticateUser, viewModel.userException.toString());
          } else {
            await showMessageToUser(
                titleCreateUser, viewModel.userException.toString());
          }
        } else {
          if (_isLogin) {
            await showMessageToUser(
                titleAuthenticateUser, messageLoginUserWithError);
          } else {
            await showMessageToUser(
                titleCreateUser, messageCreateUserWithError);
          }
        }
        setIsLoading(false);
        break;

      default:
        if (_isLogin) {
          await showMessageToUser(
              titleAuthenticateUser, messageLogiWithUndefinedError);
        } else {
          await showMessageToUser(
              titleCreateUser, messageCreateUserWithUndefinedError);
        }
        setIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: FormUserAccess(
        getIsLoading,
        getIsLogin,
        setLogin,
        _processUserRequest,
      ),
    );
  }
}
