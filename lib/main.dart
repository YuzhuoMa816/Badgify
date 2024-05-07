import 'package:badgify/pages/login/sign_in_page.dart';
import 'package:badgify/store/app_configuration_store.dart';
import 'package:badgify/store/app_store.dart';
import 'package:badgify/utils/config.dart';
import 'package:badgify/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:badgify/utils/common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'app_theme.dart';
import 'locale/app_localizations.dart';
import 'locale/language_en.dart';
import 'locale/languages.dart';
import 'material_you_modal.dart';

AppStore appStore = AppStore();

AppConfigurationStore appConfigurationStore = AppConfigurationStore();

BaseLanguage language = LanguageEn();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  localeLanguageList = languageList();

  // firebase initialise
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Firebase initialized success");
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  // setup the dark/light theme mode of the system
  int themeModeIndex =
      getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Observer(
        builder: (_) => FutureBuilder<Color>(
          future: getMaterialYouData(),
          builder: (_, snap) {
            return Observer(
              builder: (_) => MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                home: const SignIn(),
                theme: AppTheme.lightTheme(color: snap.data),
                darkTheme: AppTheme.darkTheme(color: snap.data),
                themeMode:
                    appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                title: APP_NAME,
                supportedLocales: LanguageDataModel.languageLocales(),
                localizationsDelegates: const [
                  AppLocalizations(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) => locale,
                locale: Locale(appStore.selectedLanguageCode),
              ),
            );
          },
        ),
      ),
    );
  }
}
