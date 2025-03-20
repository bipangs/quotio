import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quotio/screens/auth_screen.dart';
import 'package:quotio/screens/quote_screen.dart';
import 'package:quotio/screens/saved_quotes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/authScreen',
      routes: {
        '/authScreen': (ctx) => AuthScreen(),
        '/quoteScreen': (ctx) => QuoteScreen(),
        '/savedQuotesScreen': (ctx) => SavedQuotesScreen(),
      },
    );
  }
}
