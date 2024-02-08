import 'package:flutter/material.dart';

class EarningScreen extends StatelessWidget {
  final GlobalKey scaffoldKey;
  const EarningScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: const Center(
        child: Text('Earning Screen'),
      ),
    );
  }
}
