import 'package:flutter/material.dart';
import 'constants.dart';
import 'pages/splash_screen.dart';  // Import the SplashScreen widget
import 'pages/sign_in_page.dart';  // Import the SignInPage widget
import 'pages/sign_up_page.dart';  // Import the SignUpPage widget
import '../pages/home_page.dart'; // Import the HomePage widget
import 'services/caching_service.dart'; // Import the CacheManager class
import 'theme.dart'; // Import the theme file
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final CachingService _cachingService = CachingService();

  Future<bool> _checkToken() async {
    String? token = await _cachingService.getData(ENV.CACHE_BEARER_TOKEN_KEY);
    return (token != null);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: notYellow),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(_checkToken),
        '/home': (context) => const HomePage(),
        '/sign_in_page': (context) => const SignInPage(),
        '/sign_up_page': (context) => const SignUpPage(),
      },
    );
  }
}
