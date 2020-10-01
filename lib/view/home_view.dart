import 'package:flutter/material.dart';

import '../view_model/user_acess_view_model.dart';
import '../res/colors.dart';
import '../res/custom_icon.dart';
import '../view/layout/layout_page.dart';
import '../view/user_access/user_access.dart';
import 'evaluation/perform_evaluation/perform_evaluation_view.dart';
import 'evaluation/done_evaluation/done_evaluation_search_view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //UserModel user;
  final _viewModel = UserAccessViewModel();
  final _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  final _listOptionsPage = [
    {
      'id': 0,
      'title': 'Realizar\navaliação',
      'image': 'lib/res/images/avalia_realizar_avaliacao.png',
      'color': yellowDeepColor,
      'page': PerformEvaluationView.routeName,
    },
    {
      'id': 1,
      'title': 'Avaliações\nrealizadas',
      'image': 'lib/res/images/avalia_avaliacoes_realizadas.png',
      'color': greenDeepColor,
      'page': DoneEvaluationsSearchView.routeName,
    },
  ];

  final _listOptionsBottomPage = [
    {
      'name': 'Ajuda',
      'icon': CustomIcon.icon_help_main_menu,
      'function': null,
    },
    {
      'name': 'Perfil',
      'icon': CustomIcon.icon_edit_profile_main_menu,
      'function': null,
    },
    {
      'name': 'Sobre',
      'icon': CustomIcon.icon_about_main_menu,
      'function': null,
    },
    {
      'name': 'Sair',
      'icon': CustomIcon.icon_exit_main_menu,
      'function': null,
    },
  ];

  void _functionNothing(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int _nextPage = _pageController.page.round();
      if (_nextPage != _currentPage) {
        setState(() {
          _currentPage = _nextPage;
        });
      }
    });
    _listOptionsBottomPage[0]['function'] = _functionNothing;
    _listOptionsBottomPage[1]['function'] = _functionNothing;
    _listOptionsBottomPage[2]['function'] = _functionNothing;
    _listOptionsBottomPage[3]['function'] = _exitApplication;
  }

  void _changePageBullet(int pageId) {
    setState(() {
      _pageController.jumpToPage(pageId);
      _currentPage = pageId;
    });
  }

  void _selectNewPage(BuildContext ctx, String page, String title) {
    Navigator.of(ctx).pushNamed(
      page,
      arguments: title.replaceAll('\n', ' '),
    );
  }

  void _exitApplication(BuildContext ctx) {
    _viewModel.signOut();
    Navigator.pushReplacementNamed(
      ctx,
      UserAccessView.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // final welcomeUser = FutureBuilder(
    //   future: viewModel.getUserData(),
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     } else {
    //       if (futureSnapshot.hasData) {
    //         user = (futureSnapshot.data as UserModel);
    //       }
    //       return Container(
    //         margin: const EdgeInsets.only(
    //           top: 32.0,
    //         ),
    //         child: AppBar(
    //           centerTitle: true,
    //           elevation: 0,
    //           title: Text(
    //             user != null ? 'Olá, ${user.name}!' : 'Olá ',
    //             style: Theme.of(context).textTheme.headline5,
    //           ),
    //           actions: [
    //             PopupMenuButton(
    //               itemBuilder: (ctx) => [
    //                 PopupMenuItem(
    //                   child: Text('Editar Perfil'),
    //                   value: 'perfil',
    //                 ),
    //                 PopupMenuItem(
    //                   child: Text('Sair'),
    //                   value: 'logout',
    //                 ),
    //               ],
    //               onSelected: (value) {
    //                 if (value == 'logout') {
    //                   viewModel.signOut();
    //                 }
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //   },
    // );

    Widget _buildPage(String title, String image, Color color, String page) {
      return InkWell(
        onTap: () => _selectNewPage(context, page, title),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              padding: const EdgeInsets.only(top: 24.0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    image,
                  ),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.white12,
                //     blurRadius: 20.0,
                //     offset: Offset(10, 10),
                //   ),
                // ],
              ),
            ),
            Positioned(
              top: 10,
              left: 40,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline1.copyWith(
                      color: color,
                    ),
                child: Text(
                  title,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final _userOptionsPage = Center(
      child: Container(
        padding: EdgeInsets.only(top: deviceSize.height * 0.1),
        height: deviceSize.height * 0.56,
        width: deviceSize.width,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemCount: _listOptionsPage.length,
          itemBuilder: (context, index) {
            return _buildPage(
              _listOptionsPage[index]['title'],
              _listOptionsPage[index]['image'],
              _listOptionsPage[index]['color'],
              _listOptionsPage[index]['page'],
            );
          },
        ),
      ),
    );

    Widget _bullets = Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _listOptionsPage
            .map((item) => InkWell(
                  onTap: () => _changePageBullet(item['id']),
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _currentPage == item['id']
                          ? Colors.white
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ))
            .toList(),
      ),
    );

    Widget _userBottomOptions = Container(
      padding: const EdgeInsets.only(
        left: 16.0,
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _listOptionsBottomPage.map((item) {
          Function actionFunction = item['function'] as Function;
          return Theme(
            data: ThemeData.light().copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: InkWell(
              onTap: () => actionFunction(context),
              child: Container(
                margin: const EdgeInsets.only(
                  right: 8,
                ),
                //height: deviceSize.height * 0.13,
                width: deviceSize.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: blueBrightColor,
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item['name'],
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.left,
                      ),
                      Center(
                        child: Icon(
                          item['icon'],
                          color: whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    Widget _content = Container(
      height: deviceSize.height * 0.92,
      child: Column(
        children: [
          _userOptionsPage,
          _bullets,
          Expanded(
            child: _userBottomOptions,
          )
        ],
      ),
    );

    return LayoutPage.render(
      hasHeader: false,
      hasFirstButton: false,
      hasHeaderLogo: false,
      context: context,
      color: Theme.of(context).primaryColor,
      content: _content,
    );
  }
}
