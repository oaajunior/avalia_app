import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash-screen';
  final bool isTransparent;
  SplashScreen({this.isTransparent});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isTransparent ? Colors.transparent : Theme.of(context).primaryColor,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}
