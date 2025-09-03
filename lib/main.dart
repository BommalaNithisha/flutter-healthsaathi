import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:healthsaathi/languages/translations_service.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';
import 'package:healthsaathi/screens/splash_screen.dart';
import 'package:healthsaathi/services/notification_service.dart';
//import 'package:healthsaathi/lang/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().init();
  await NotificationService().requestPermissions();
  tz.initializeTimeZones();

  runApp(const HealthSaathiApp());
}

class HealthSaathiApp extends StatelessWidget {
  const HealthSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HealthSaathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),

      translations: TranslationService(), //  Load translations
      locale: TranslationService.locale, //   Initial locale
      fallbackLocale: TranslationService.fallbackLocale,

      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
      ],
    );
  }
}
