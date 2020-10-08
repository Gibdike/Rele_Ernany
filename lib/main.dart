import 'package:controle_bluetooth/page/bluetooth_disable.page.dart';
import 'package:controle_bluetooth/page/home.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador Relé',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (_, snapshot) {
          final state = snapshot.data;
          /* Se o bluetooth do aparelho não estiver ativado,
          * mostra uma tela de aviso. A tela só sofrerá alteração
          * caso o bluetooth seja ativado
          * */
          if (state == BluetoothState.on)
            return HomePage();
          else
            return BluetoothDisable();
        },
      ),
    );
  }
}
