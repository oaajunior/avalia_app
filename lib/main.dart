import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import './avalia.dart';

import 'res/custom_themes.dart';
import './router.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Avalia App',
      theme: basicTheme(),
      onGenerateRoute: router.generateRoute,
      debugShowCheckedModeBanner: false,
      home: Avalia(),
    ),
  );
}
