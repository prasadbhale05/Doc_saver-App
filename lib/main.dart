import 'package:doc_saver_app/firebase_options.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:doc_saver_app/provider/userInfo_provider.dart';
import 'package:doc_saver_app/screens/add_doc_screen.dart';
import 'package:doc_saver_app/screens/authentication.dart';
import 'package:doc_saver_app/screens/doc_viewscreen.dart';
import 'package:doc_saver_app/screens/forgetpass_screen.dart';
import 'package:doc_saver_app/screens/homescreen.dart';
import 'package:doc_saver_app/screens/settings_screen.dart';
import 'package:doc_saver_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          AuthScreen.routeName: (context) => const AuthScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ForgetPassScreen.routeName: (context) => const ForgetPassScreen(),
          AddDocumentScreen.routeName: (context) => const AddDocumentScreen(),
          DocViewScreen.routeName: (context) => const DocViewScreen(),
          SettingScreen.routeName: (context) => const SettingScreen(),
          SplashScreen.routeName: (context) => const SplashScreen(),
        },
      ),
    );
  }
}
