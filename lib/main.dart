import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';
import 'package:thbensem_portfolio/pages/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppTheme())
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: context.read<AppTheme>().color0,
        textTheme: TextTheme(bodyMedium: TextStyle(color: context.read<AppTheme>().textColor0)),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 34, 126, 192)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
