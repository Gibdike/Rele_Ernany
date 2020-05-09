import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  String msg;

  LoadingPage({this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(msg, style: TextStyle(fontSize: 18, color: Colors.red))
          ],
        ),
      ),
    );
  }
}
