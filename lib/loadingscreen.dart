import 'package:flutter/material.dart';
import 'package:prakty/main.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      height: double.infinity,
      width: double.infinity,
      child: Center(
          child: CircularProgressIndicator(
              backgroundColor: gradient[0],
              color: gradient[1],
              strokeWidth: 10)),
    );
  }
}
