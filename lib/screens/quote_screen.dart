import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quotio/screens/auth_screen.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String _quote = '';
  String _author = '';
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _getQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random'));
    final data = jsonDecode(response.body);
    setState(() {
      _quote = data[0]['q'];
      _author = data[0]['a'];
    });
  }
  //create collection in firestore to store quotes
  Future<void> _saveQuote() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .add({
        'quote': _quote,
        'author': _author,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quote saved successfully!'),
          backgroundColor: Color(0xff388e3c),
        ),
      );
    }
  }

  void _viewSavedQuotes() {
    Navigator.of(context).pushNamed('/savedQuotesScreen');
  }

  Future<void> _logOut() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/authScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveQuote,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _viewSavedQuotes,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_quote.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _quote,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_author.isNotEmpty)
              Text(
                _author,
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getQuote,
              child: const Text('Get Quote'),
            ),
          ],
        ),
      ),
    );
  }
}
