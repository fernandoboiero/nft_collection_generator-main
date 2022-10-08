import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:nft_generator/core/infrastructure/dependency_injection.dart'
    as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nft_generator/features/collection_generator/presentation/pages/collection_generator_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await di.setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GlobalLoaderOverlay(child: CollectionGeneratorPage()),
    );
  }
}
