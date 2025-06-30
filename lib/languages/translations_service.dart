import 'dart:ui';

import 'package:get/get.dart';
import 'en_us.dart';
import 'hi_in.dart';

class TranslationService extends Translations {
  static const locale = Locale('en', 'US');
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'hi_IN': hiIN,
      };
}
