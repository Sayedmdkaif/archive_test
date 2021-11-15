import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/screen/SplashScreen_0.dart';
import 'package:zacharchive_flutter/utils/Prefs.dart';

import 'common/Strings.dart';
import 'utils/PortraitModeMixin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  /* await SentryFlutter.init(
        (options) {
      options.dsn = 'https://8f0f0501c6a34ef08dc82eb38c15b1d0@o1016680.ingest.sentry.io/5982080';
    },
    appRunner: () => runApp(MyApp()),
  );*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: materialColor(),
      ),
      home: SplashScreen(),
    );
  }
}

materialColor() {
  Map<int, Color> colorCodes = {
    50: Color(0xFFEBF8FF),
    100: Color(0xFFEBF8FF),
    200: Color(0xFFEBF8FF),
    300: Color(0xFFEBF8FF),
    400: Color(0xFFEBF8FF),
    500: Color(0xFFEBF8FF),
    600: Color(0xFFEBF8FF),
    700: Color(0xFFEBF8FF),
    800: Color(0xFFEBF8FF),
    900: Color(0xFFEBF8FF),
  };
  // Green color code: FF93cd48
  MaterialColor customColor = MaterialColor(0xFFEBF8FF, colorCodes);

  return customColor;
}
