import 'package:flutter/material.dart';

import './view/user_access/user_access.dart';
import './view/evaluation/done_evaluations/done_evaluations_view.dart';
import './view/evaluation/perform_evaluation/perform_evaluation_view.dart';
import './view/evaluation/perform_evaluation/realizar_avaliacao_busca_view.dart';
import './view/home_view.dart';

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
    case PerformEvaluationView.routeName:
      builder = (context) => PerformEvaluationView(arguments);
      break;
    case RealizarAvaliacaoBuscaView.routeName:
      builder = (context) => RealizarAvaliacaoBuscaView(arguments);
      break;
    case DoneEvaluationsView.routeName:
      builder = (context) => DoneEvaluationsView();
      break;
    default:
      builder = (context) => UserAccessView();
  }

  return MaterialPageRoute(
    builder: builder,
    settings: settings,
  );
}
