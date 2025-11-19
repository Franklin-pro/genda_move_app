import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: InkWell(
        onTap: null,
        borderRadius: BorderRadius.all( Radius.circular(16)),
        child: Stack(
          children: [
            
          ],
        ),
      ),
    );
  }
}