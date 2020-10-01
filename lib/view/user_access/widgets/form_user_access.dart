import 'package:avalia_app/view/layout/layout_buttons.dart';
import 'package:avalia_app/view/layout/layout_text_fields.dart';
import 'package:flutter/material.dart';

import '../../../utils/type_user.dart';
import '../../../res/colors.dart';

class FormUserAccess extends StatefulWidget {
  final Function isLoading;
  final Function isLogin;
  final Function setLogin;
  final Function processUserRequest;

  final userEmailLastLogin;
  FormUserAccess(
    this.isLoading,
    this.isLogin,
    this.setLogin,
    this.processUserRequest,
    this.userEmailLastLogin,
  );

  @override
  _FormUserAccessState createState() => _FormUserAccessState();
}

class _FormUserAccessState extends State<FormUserAccess> {
  final _formKey = GlobalKey<FormState>();

  String _userName = '';
  String _userSurname = '';
  String _userEmail = '';
  String _userPassword = '';
  Widget _texFieldName;
  Widget _textFieldSurname;
  Widget _textFieldEmail;
  Widget _textFieldPassword;
  Widget _textFieldRepeatedPassword;
  TypeOfUser _userType = TypeOfUser.Student;
  FocusNode _usernameFocus;
  FocusNode _surnameFocus;
  FocusNode _emailFocus;
  FocusNode _typeOfUserFocus;
  FocusNode _passwordFocus;
  FocusNode _repeatedPasswordFocus;
  FocusNode _userTypeFocus;
  TextEditingController _passwordController = TextEditingController();
  bool _showUserPassword = false;
  bool _showUserRepeteadPassword = false;

  @override
  void initState() {
    super.initState();
    _usernameFocus = FocusNode();
    _surnameFocus = FocusNode();
    _emailFocus = FocusNode();
    _typeOfUserFocus = FocusNode();
    _passwordFocus = FocusNode();
    _repeatedPasswordFocus = FocusNode();
    _userTypeFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameFocus.dispose();
    _surnameFocus.dispose();
    _emailFocus.dispose();
    _typeOfUserFocus.dispose();
    _passwordFocus.dispose();
    _repeatedPasswordFocus.dispose();
    _passwordController.dispose();
  }

  String _validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Por favor, informe um nome.';
    } else {
      if (value.length < 2) {
        return 'Por favor, informe um nome válido!';
      }
    }
    return null;
  }

  String _validateSurname(String value) {
    if (value.trim().isEmpty) {
      return 'Por favor, informe um sobrenome.';
    } else {
      if (value.length < 2) {
        return 'Por favor, informe um sobrenome válido!';
      }
    }
    return null;
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.trim().isEmpty) {
      return 'Por favor, informe o e-mail.';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Por favor, informe um e-mail válido!';
      }
    }
    return null;
  }

  String _validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (value.trim().isEmpty) {
      return 'Por favor, informe sua senha.';
    } else {
      if (!regex.hasMatch(value)) {
        return 'A senha deve conter no mínimo 8 caracteres com letras maiúsculas, minúsculas, números, e símbolos (\$@!&%).';
      }
    }
    return null;
  }

  String _validatePasswordLogin(String value) {
    if (value.trim().isEmpty) {
      return 'Por favor, informe sua senha.';
    }
    return null;
  }

  String _validateRepeatedPassword(String firstValue, String secondValue) {
    if (firstValue != secondValue) {
      return 'As senhas informadas não coincidem!';
    } else if (secondValue.isEmpty) {
      return 'Por favor, repita a senha informada.';
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState.reset();
    _passwordController.text = '';
    _userEmail = '';
  }

  void _trySubmit() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      _formKey.currentState.save();

      widget.processUserRequest(
        _userName,
        _userSurname,
        _userEmail,
        _userPassword,
        _userType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    _texFieldName = LayoutTextFields.customTextFields(
      key: ValueKey('name'),
      focusNode: _usernameFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_surnameFocus);
      },
      textCapitalization: TextCapitalization.words,
      validator: (name) => _validateName(name),
      onSaved: (name) {
        _userName = name.trim().toString().toLowerCase().capitalizeFirstofEach;
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(deviceSize.height * 0.025),
        hintText: 'Nome',
        hintStyle: TextStyle(
          color: whitSoftColor,
        ),
      ),
    );

    _textFieldSurname = LayoutTextFields.customTextFields(
      key: ValueKey('surname'),
      focusNode: _surnameFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      validator: (surname) => _validateSurname(surname),
      onSaved: (surname) {
        _userSurname =
            surname.trim().toString().toLowerCase().capitalizeFirstofEach;
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(deviceSize.height * 0.025),
        hintText: 'Sobrenome',
        hintStyle: TextStyle(
          color: whitSoftColor,
        ),
      ),
    );

    _textFieldEmail = LayoutTextFields.customTextFields(
      key: ValueKey('email'),
      focusNode: _emailFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      validator: (email) {
        _userEmail = email.trim();
        return _validateEmail(email.trim());
      },
      onSaved: (email) {
        _userEmail = email.trim();
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(deviceSize.height * 0.025),
        hintText: 'E-mail',
        hintStyle: TextStyle(
          color: whitSoftColor,
        ),
      ),
      initialValue: (widget.isLogin() && !widget.isLoading())
          ? widget.userEmailLastLogin
          : null,
    );

    _textFieldPassword = LayoutTextFields.customTextFields(
      key: ValueKey('password'),
      controller: _passwordController,
      focusNode: _passwordFocus,
      textInputAction: widget.isLogin() ? null : TextInputAction.next,
      onFieldSubmitted: widget.isLogin()
          ? (_) => _trySubmit()
          : (_) {
              FocusScope.of(context).requestFocus(_repeatedPasswordFocus);
            },
      validator: (password) => widget.isLogin()
          ? _validatePasswordLogin(password)
          : _validatePassword(password),
      onSaved: (password) {
        _userPassword = password.trim();
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(deviceSize.height * 0.025),
        errorMaxLines: 5,
        hintText: 'Senha',
        hintStyle: TextStyle(
          color: whitSoftColor,
        ),
        prefix: Padding(
          padding: const EdgeInsets.only(left: 55.0),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
                _showUserPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showUserPassword = !_showUserPassword;
              });
            },
            color: whitSoftColor,
          ),
        ),
      ),
      obscureText: _showUserPassword ? false : true,
    );

    _textFieldRepeatedPassword = LayoutTextFields.customTextFields(
      key: ValueKey('repeatedPassword'),
      focusNode: _repeatedPasswordFocus,
      validator: (repeatedPassword) =>
          _validateRepeatedPassword(_passwordController.text, repeatedPassword),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_userTypeFocus);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(deviceSize.height * 0.025),
        hintText: 'Confirmação Senha',
        hintStyle: TextStyle(
          color: whitSoftColor,
        ),
        prefix: Padding(
          padding: const EdgeInsets.only(left: 42.0),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(_showUserRepeteadPassword
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showUserRepeteadPassword = !_showUserRepeteadPassword;
              });
            },
            color: whitSoftColor,
          ),
        ),
      ),
      obscureText: _showUserRepeteadPassword ? false : true,
      enableInteractiveSelection: false,
    );

    final radioTypeUser = Container(
      width: deviceSize.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Radio(
                    focusNode: _userTypeFocus,
                    value: TypeOfUser.Student,
                    groupValue: _userType,
                    onChanged: (TypeOfUser value) {
                      setState(() {
                        _userType = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Aluno',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Radio(
                    value: TypeOfUser.Teacher,
                    toggleable: true,
                    groupValue: _userType,
                    onChanged: (TypeOfUser value) {
                      setState(() {
                        _userType = value;
                      });
                    },
                  ),
                ),
                Text(
                  'Professor',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final _buttons = Flexible(
      flex: widget.isLogin() ? 1 : 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LayoutButtons.customRaisedButtons(
            textRaisedButtonOne: widget.isLogin() ? 'Acessar' : 'Cadastrar',
            color: blueDeepColor,
            context: context,
            onPressedButtonOne: _trySubmit,
          ),
          LayoutButtons.customFlatButtons(
            context: context,
            text: widget.isLogin()
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'É novo por aqui? ',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).accentColor,
                              decoration: TextDecoration.underline,
                            ),
                        child: Text(
                          'Cadastre-se!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : 'Cancelar',
            onPressed: () {
              _resetForm();
              widget.setLogin(!widget.isLogin());
              widget.isLogin()
                  ? _emailFocus.requestFocus()
                  : _usernameFocus.requestFocus();
            },
          ),
        ],
      ),
    );

    final _content = AnimatedContainer(
      duration: Duration(
        microseconds: 3000,
      ),
      curve: Curves.easeIn,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.isLogin()
              ? deviceSize.height * 0.4
              : deviceSize.height * 0.8,
          maxHeight: widget.isLogin()
              ? deviceSize.height * 0.65
              : deviceSize.height * 1.6,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isLogin()) _texFieldName,
              if (!widget.isLogin()) _textFieldSurname,
              _textFieldEmail,
              _textFieldPassword,
              if (!widget.isLogin()) _textFieldRepeatedPassword,
              SizedBox(
                height: 12,
              ),
              if (!widget.isLogin()) radioTypeUser,
              SizedBox(
                height: 12,
              ),
              if (widget.isLoading() && widget.isLogin())
                CircularProgressIndicator(),
              if (widget.isLoading())
                SizedBox(
                  height: 8,
                ),
              _buttons,
            ],
          ),
        ),
      ),
    );

    return _content;
  }
}

extension CapExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.capitalize).join(" ");
}
