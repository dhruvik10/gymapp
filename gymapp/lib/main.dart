import 'package:flutter/material.dart';
import 'package:gymapp/pages/gym_app.dart';
import 'package:gymapp/providers/gym_app_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Flag>(create: (_) => Flag()),
      ],
      child: MaterialApp(
        title: 'Gym App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const GymApp(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
