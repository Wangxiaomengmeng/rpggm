import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'ui/main_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => GameProvider(),
      child: MaterialApp(
        title: '超肝联机RPG',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}