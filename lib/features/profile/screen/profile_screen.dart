import 'package:flutter/material.dart';

import '../../appbar/screen/appbar_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarScreen(title: 'Account'),
      body: Center(child: Text('Profile')),
    );
  }
}
