import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Controle de ar condicionado"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container();
  }
}
