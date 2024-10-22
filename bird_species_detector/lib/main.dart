import 'package:bird_species_detector/ai_model_utility.dart';
import 'package:bird_species_detector/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BirdClassifier birdClassifier = BirdClassifier();

  await birdClassifier.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => birdClassifier,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BirdPic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

