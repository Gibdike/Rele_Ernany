import 'package:controle_bluetooth/bluetoothDesabilitado.dart';
import 'package:controle_bluetooth/home.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Ar Condicionado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (_, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on)
            return HomePage();
          else
            return BluetoothDesabilitado();
        },
      ),
    );
  }
}
