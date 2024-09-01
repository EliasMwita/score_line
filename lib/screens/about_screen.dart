import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About page"),
      ),
      body: const SingleChildScrollView(
        child: Center(),
      ),
    );
  }
}
