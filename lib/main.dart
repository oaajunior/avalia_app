//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:device_preview/device_preview.dart';
import './avalia.dart';

import 'res/custom_theme.dart';
import './router.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) =>
    MaterialApp(
      title: 'Avalia App',
      theme: basicTheme(),
      onGenerateRoute: router.generateRoute,
      //locale: DevicePreview.of(context).locale,
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: Avalia(),
    ),
    //),
  );
}
