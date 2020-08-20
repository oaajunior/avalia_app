import 'package:flutter/material.dart';

import '../view_model/user_acess_view_model.dart';
import '../model/user/user_model.dart';
import './avaliacao/realizar_avaliacao_view.dart';
import './avaliacao/avaliacoes_realizadas_view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final viewModel = UserAccessViewModel();
  UserModel user;

  void _selectNewPage(BuildContext ctx, String page, String title) {
    Navigator.of(ctx).pushNamed(
      page,
      arguments: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final welcomeUser = FutureBuilder(
      future: viewModel.getUserData(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (futureSnapshot.hasData) {
            user = (futureSnapshot.data as UserModel);
          }
          return Container(
            margin: const EdgeInsets.only(
              top: 32.0,
            ),
            child: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(
                user != null ? 'Olá, ${user.name}!' : 'Olá ',
                style: Theme.of(context).textTheme.headline5,
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
          );
        }
      },
    );

    Widget _buildItemListView(String title, String page) {
      return InkWell(
        onTap: () => _selectNewPage(context, page, title),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 24),
            height: deviceSize.height * 0.5,
            width: deviceSize.width * 0.8,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ),
      );
    }

    final userOptions = Center(
      child: Container(
        padding: const EdgeInsets.only(top: 56),
        height: deviceSize.height * 0.5,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildItemListView(
                'Realizar Avaliação', RealizarAvaliacaoScreen.routeName),
            _buildItemListView(
                'Avaliações Realizadas', AvaliacoesRealizadasView.routeName),
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              welcomeUser,
              userOptions,
            ],
          ),
        ),
      ),
    );
  }
}
