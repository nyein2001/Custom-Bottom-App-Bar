import 'package:flutter/material.dart';

class DriveScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DriveScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: const Center(
        child: Text('Drive Screen'),
      ),
    );
  }
}
