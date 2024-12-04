
import 'package:flutter/material.dart';

class AppProgressDialog extends StatelessWidget {
  const AppProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        height: 80,
        width: 80,
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Colors.white,),
        ),
      ),
    );
  }
}
