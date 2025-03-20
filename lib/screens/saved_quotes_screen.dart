import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedQuotesScreen extends StatelessWidget {
  const SavedQuotesScreen({super.key});

  //delete quote from firestore
  Future<void> _deleteQuote(String userId, String quoteId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(quoteId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Quotes'),
        ),
        body: const Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Quotes'),
      ),
      //retrieve quotes from firestore / read operation
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final quotes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return ListTile(
                title: Text(quote['quote']),
                subtitle: Text(quote['author']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteQuote(user.uid, quote.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
