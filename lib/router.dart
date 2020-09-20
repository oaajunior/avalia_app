import 'package:avalia_app/view/evaluation/perform_evaluation/widgets/perform_evaluation_start.dart';
import 'package:avalia_app/view/ranking/ranking_view.dart';
import 'package:flutter/material.dart';

import './view/user_access/user_access.dart';
import './view/evaluation/perform_evaluation/perform_evaluation_view.dart';
import './view/evaluation/done_evaluation/done_evaluation_list_view.dart';
import './view/evaluation/done_evaluation/done_evaluation_search_view.dart';
import './view/evaluation/perform_evaluation/perform_evaluation_questions_view.dart';
import 'view/evaluation/perform_evaluation/perform_evaluation_prepare_view.dart';
import './view/evaluation/done_evaluation/done_evaluation_question_answers_view.dart';
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
    case PerformEvaluationQuestionsView.routeName:
      builder = (context) => PerformEvaluationQuestionsView(arguments);
      break;
    case PerformEvaluationPrepareView.routeName:
      builder = (context) => PerformEvaluationPrepareView(arguments);
      break;
    case PerformEvaluationStart.routeName:
      builder = (context) => PerformEvaluationStart(arguments);
      break;
    case DoneEvaluationsSearchView.routeName:
      builder = (context) => DoneEvaluationsSearchView(arguments);
      break;
    case DoneEvaluationListView.routeName:
      builder = (context) => DoneEvaluationListView(arguments);
      break;
    case DoneEvaluationQuestionAnswersView.routeName:
      builder = (context) => DoneEvaluationQuestionAnswersView(arguments);
      break;
    case RankingView.routeName:
      builder = (context) => RankingView(arguments);
      break;
    default:
      builder = (context) => UserAccessView();
  }

  return MaterialPageRoute(
    builder: builder,
    settings: settings,
  );
}
