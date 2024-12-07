import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/screen/onBoardingScreen.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/favorite_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  await Hive.openBox('favoriteList');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
    );
  }
}
