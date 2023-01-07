import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.brown.shade900,
            appBarTheme:
                AppBarTheme(backgroundColor: Colors.transparent, elevation: 0)),
        title: "Notepadku",
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
        });
  }
}
