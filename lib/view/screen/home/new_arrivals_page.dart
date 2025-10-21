import 'package:flutter/material.dart';

class NewArrivalsPage extends StatelessWidget {
  const NewArrivalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Arrivals'),
      ),
      body: const Center(
        child: Text('This is the New Arrivals page. Coming soon!'),
      ),
    );
  }
}
