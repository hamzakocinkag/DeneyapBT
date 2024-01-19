import 'package:deneyap/pages/home.dart';
import 'package:deneyap/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Wakelock.enable();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF0D1117),
      statusBarColor: Color(0xFF0D1117),
    ),
  );

  runApp(GetMaterialApp(
    title: "DeneyapBT",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'GoogleSans',
      scaffoldBackgroundColor: const Color(0xFF0D1117),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.indigoAccent.shade400,
        background: Colors.white.withOpacity(0.05),
      ),
      splashColor: Colors.white.withOpacity(0.05),
    ),
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const Home()),
      GetPage(name: '/settings', page: () => const Settings()),
    ],
  ));
}
