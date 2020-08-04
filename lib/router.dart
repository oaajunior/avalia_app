import 'package:flutter/material.dart';

import './view/user_access/user_access.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var arguments = settings.arguments;
  var builder;
  switch (settings.name) {
    case UserAccessView.routeName:
      builder = (context) => UserAccessView();
      break;

    default:
      builder = (context) => UserAccessView();
  }

  return MaterialPageRoute(builder: builder);
}
