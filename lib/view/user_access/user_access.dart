import 'package:flutter/material.dart';

import '../../view/home_view.dart';
import './widgets/form_user_access.dart';
import '../../view_model/user_acess_view_model.dart';
import '../../model/user/user_model.dart';
import '../../utils/loading_status.dart';
import '../../utils/type_user.dart';
import '.././layout/layout_page.dart';
import '../../res/colors.dart';
import '../../view/layout/layout_alert.dart';

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

  Future<void> showMessageToUser(
    String title,
    String message,
  ) {
    final customMessage = Text(
      message,
      textAlign: TextAlign.center,
    );

    final button = RaisedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
        child: Text(
          'Ok',
          textAlign: TextAlign.center,
        ),
      ),
    );

    return LayoutAlert.customAlert(
      title: title,
      message: customMessage,
      colorTitle: Theme.of(context).primaryColor,
      color: blackSoftColor,
      context: context,
      actionButtons: button,
      barrierDismissible: false,
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
    final titleAuthenticateUser = 'Autenticação de Usuário';
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
        Navigator.of(context).pushReplacementNamed(HomeView.routeName);
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
    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: false,
      context: context,
      hasHeaderLogo: true,
      //headerTitle: 'avalia',
      //mainText: _isLogin ? 'Acessar' : 'Cadastrar',
      color: blueDeepColor,
      content: FormUserAccess(
        getIsLoading,
        getIsLogin,
        setLogin,
        _processUserRequest,
      ),
    );
  }
}
