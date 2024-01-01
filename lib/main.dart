import 'package:chat_app_2/controllers/detail_page_controller.dart';
import 'package:chat_app_2/helpers/auth_helper.dart';
import 'package:chat_app_2/views/screens/chat_page.dart';
import 'package:chat_app_2/views/screens/details_page.dart';
import 'package:chat_app_2/views/screens/home_page.dart';
import 'package:chat_app_2/views/screens/login_page.dart';
import 'package:chat_app_2/views/screens/signUp_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DetailPageController()),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute:
          Auth.auth.firebaseAuth.currentUser != null ? 'home_page' : '/',
      routes: {
        '/': (context) => LoginPage(),
        'signUp_page': (context) => SignUpPage(),
        'home_page': (context) => HomePage(),
        'detail_page': (context) => DetailsPage(),
        'chat_page': (context) => ChatPage(),
      },
    );
  }
}
