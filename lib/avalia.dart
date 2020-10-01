import 'package:flutter/material.dart';

import 'view/user_access/user_access.dart';
import 'view_model/user_acess_view_model.dart';
import 'view/splash_screen.dart';
import 'view/home_view.dart';

class Avalia extends StatelessWidget {
  final viewModel = UserAccessViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: viewModel.getCurrentUser(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(
              isTransparent: false,
            );
          }
          if (userSnapshot.hasData) {
            return HomeView();
          }
          return UserAccessView();
        },
      ),
    );
  }
}
