import 'package:decemvir/api/prefs.dart';
import 'package:decemvir/ui/app.dart';
import 'package:decemvir/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yaru/yaru.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPrefs();

  runApp(const MyMaterialApp());
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MyApp(),
      supportedLocales: const [
        Locale('de'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

void push(BuildContext context, Widget page, {bool replace = false}) {
  final route = MaterialPageRoute(builder: (context) => page);

  if (replace) {
    Navigator.of(context).pushReplacement(route);
  } else {
    Navigator.of(context).push(route);
  }
}
