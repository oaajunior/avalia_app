import 'package:avalia_app/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'router.dart' as router;
import './view/user_access/user_access.dart';
import './res/colors.dart';
import './view_model/user_acess_view_model.dart';
import 'view/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Avalia App',
      theme: _buildTheme(),
      onGenerateRoute: router.generateRoute,
      debugShowCheckedModeBanner: false,
      home: AvaliaApp(),
    ),
  );
}

class AvaliaApp extends StatelessWidget {
  final viewModel = UserAccessViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: viewModel.verifyAuthUser(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
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

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: mainColor,
    accentColor: mainDarkColor,
    primaryColorLight: mainLightColor,
    backgroundColor: mainBackgroundColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: mainDarkColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      textTheme: ButtonTextTheme.normal,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dialogTheme: base.dialogTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: mainBackgroundColor,
      elevation: 1,
    ),
    textTheme: base.textTheme.copyWith(
      headline3: TextStyle(
        fontWeight: FontWeight.bold,
        color: mainDarkColor,
      ),
      headline5: TextStyle(
        fontWeight: FontWeight.bold,
        color: mainBackgroundColor,
      ),
    ),
  );
}
