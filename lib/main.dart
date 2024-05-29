import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/models/providers/l10n.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';
import 'package:thbensem_portfolio/models/shared_preferences.dart';
import 'package:thbensem_portfolio/pages/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => L10n()),
        ChangeNotifierProvider(create: (_) => AppTheme())
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocale().then((languageCode) => context.read<L10n>().setLocale(languageCode));
      _initTheme().then((themeIndex) => context.read<AppTheme>().setTheme(themeIndex));
    });
  }

  Future<String> _initLocale() async {
    final String? codeStored = await SharedPreferencesManager.getLanguageCode();
    if (codeStored != null) return codeStored;

    return 'en';
  }

  Future<int> _initTheme() async {
    final int? codeStored = await SharedPreferencesManager.getThemeIndex();
    if (codeStored != null) return codeStored;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio | Thomas Bensemhoun',
      locale: Provider.of<L10n>(context).currentLocale,
      supportedLocales: L10n.locales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData(
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: context.read<AppTheme>().color0,
        textTheme: TextTheme(bodyMedium: TextStyle(color: context.read<AppTheme>().textColor0)),
        colorScheme: ColorScheme.fromSeed(seedColor: context.read<AppTheme>().color1),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
