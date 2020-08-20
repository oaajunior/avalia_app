import 'package:avalia_app/view/home_view.dart';
import 'package:flutter/material.dart';

import './view/user_access/user_access.dart';
import './view/avaliacao/avaliacoes_realizadas_view.dart';
import './view/avaliacao/realizar_avaliacao_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var arguments = settings.arguments;
  var builder;
  switch (settings.name) {
    case UserAccessView.routeName:
      builder = (context) => UserAccessView();
      break;
    case HomeView.routeName:
      builder = (context) => HomeView();
      break;
    case RealizarAvaliacaoScreen.routeName:
      builder = (context) => RealizarAvaliacaoScreen(arguments);
      break;
    case AvaliacoesRealizadasView.routeName:
      builder = (context) => AvaliacoesRealizadasView();
      break;
    default:
      builder = (context) => UserAccessView();
  }

  return MaterialPageRoute(
    builder: builder,
    settings: settings,
  );
}
