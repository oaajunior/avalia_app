import 'package:flutter/material.dart';

import '../view_model/user_acess_view_model.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final viewModel = UserAccessViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(
            top: 24.0,
          ),
          child: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'ALUNO',
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    child: Text('Editar Perfil'),
                    value: 'perfil',
                  ),
                  PopupMenuItem(
                    child: Text('Sair'),
                    value: 'logout',
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    viewModel.signOut();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      preferredSize: Size.fromHeight(100.0),
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          child: Text('Home View'),
        ),
      ),
    );
  }
}
