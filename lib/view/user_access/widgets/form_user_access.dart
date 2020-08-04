import 'package:flutter/material.dart';

import '../../../utils/type_user.dart';

class FormUserAccess extends StatefulWidget {
  final Function isLoading;
  final Function isLogin;
  final Function setLogin;
  final Function processUserRequest;
  FormUserAccess(
      this.isLoading, this.isLogin, this.setLogin, this.processUserRequest);

  @override
  _FormUserAccessState createState() => _FormUserAccessState();
}

class _FormUserAccessState extends State<FormUserAccess> {
  final _formKey = GlobalKey<FormState>();

  String _userName = '';
  String _userSurname = '';
  String _userEmail = '';
  String _userPassword = '';
  TypeOfUser _userType = TypeOfUser.Student;
  FocusNode _usernameFocus;
  FocusNode _surnameFocus;
  FocusNode _emailFocus;
  FocusNode _typeOfUserFocus;
  FocusNode _passwordFocus;
  FocusNode _repeatedPasswordFocus;
  FocusNode _userTypeFocus;
  TextEditingController informedPassword = TextEditingController();
  bool _showUserPassword = false;

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
        return 'A senha informada não é válida!\nEla deve conter no mínimo 8 caracteres\ncom letra maiúscula, minúscula e símbolos(\$@!&%).';
      }
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
  }

  void _trySubmit() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      _formKey.currentState.save();

      widget.processUserRequest(
          _userName, _userSurname, _userEmail, _userPassword, _userType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Center(
        child: AnimatedContainer(
          duration: Duration(
            microseconds: 300,
          ),
          height: widget.isLogin()
              ? deviceSize.height * 0.5
              : deviceSize.height * 0.9,
          width: deviceSize.width * 0.9,
          curve: Curves.easeIn,
          constraints: BoxConstraints(
            maxHeight: widget.isLogin()
                ? deviceSize.height * 0.5
                : deviceSize.height * 0.9,
            maxWidth: deviceSize.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: Card(
              elevation: 1,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!widget.isLogin())
                        TextFormField(
                          key: ValueKey('name'),
                          focusNode: _usernameFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_surnameFocus);
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          validator: (name) => _validateName(name),
                          onSaved: (name) {
                            _userName = name.trim();
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Nome:',
                          ),
                        ),
                      if (!widget.isLogin())
                        TextFormField(
                          key: ValueKey('surname'),
                          focusNode: _surnameFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          validator: (surname) => _validateSurname(surname),
                          onSaved: (surname) {
                            _userSurname = surname.trim();
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Sobrenome:',
                          ),
                        ),
                      TextFormField(
                        key: ValueKey('email'),
                        focusNode: _emailFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (email) => _validateEmail(email.trim()),
                        onSaved: (email) {
                          _userEmail = email.trim();
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'E-mail:',
                        ),
                      ),
                      TextFormField(
                        controller: informedPassword,
                        key: ValueKey('password'),
                        focusNode: _passwordFocus,
                        textInputAction:
                            widget.isLogin() ? null : TextInputAction.next,
                        onFieldSubmitted: widget.isLogin()
                            ? (_) => _trySubmit()
                            : (_) {
                                FocusScope.of(context)
                                    .requestFocus(_repeatedPasswordFocus);
                              },
                        validator: (password) => _validatePassword(password),
                        onSaved: (password) {
                          _userPassword = password.trim();
                        },
                        decoration: InputDecoration(
                          labelText: 'Senha:',
                          suffixIcon: IconButton(
                            icon: Icon(_showUserPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showUserPassword = !_showUserPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _showUserPassword ? false : true,
                      ),
                      if (!widget.isLogin())
                        TextFormField(
                          key: ValueKey('repeatedPassword'),
                          focusNode: _repeatedPasswordFocus,
                          validator: (repeatedPassword) =>
                              _validateRepeatedPassword(
                                  informedPassword.text, repeatedPassword),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_userTypeFocus);
                          },
                          decoration:
                              InputDecoration(labelText: 'Confirmação Senha:'),
                          obscureText: _showUserPassword ? false : true,
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      if (!widget.isLogin())
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
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
                                  Text('Aluno'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: TypeOfUser.Teacher,
                                      groupValue: _userType,
                                      onChanged: (TypeOfUser value) {
                                        setState(() {
                                          _userType = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Text('Professor'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      if (widget.isLoading()) CircularProgressIndicator(),
                      if (!widget.isLoading())
                        RaisedButton(
                          shape: ButtonTheme.of(context).shape,
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          onPressed: () {
                            _trySubmit();
                          },
                          child: widget.isLogin()
                              ? Text('Entrar')
                              : Text('Cadastrar'),
                        ),
                      if (!widget.isLoading())
                        FlatButton(
                          onPressed: () {
                            _resetForm();
                            widget.setLogin(!widget.isLogin());
                            widget.isLogin()
                                ? _emailFocus.requestFocus()
                                : _usernameFocus.requestFocus();
                          },
                          textColor: Theme.of(context).primaryColor,
                          child: widget.isLogin()
                              ? Text(
                                  'É novo por aqui? Cadastre-se!',
                                )
                              : Text(
                                  'Eu já tenho uma conta!',
                                ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
