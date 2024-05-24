import 'package:flutter/material.dart';
import 'package:thbensem_portfolio/pages/home.dart';

void main() {
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 34, 126, 192)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
