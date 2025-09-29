import 'package:flutter/material.dart';


class DisplayDataPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DisplayDataPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['judul'] ?? 'Judul tidak tersedia'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(  
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['detail'] ?? 'Detail tidak tersedia',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify, 
            ),
          ],
        ),
      ),
    );
  }
}
