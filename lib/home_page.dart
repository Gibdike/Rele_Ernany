import 'package:controle_bluetooth/log_controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _logController = LogController();

  @override
  void initState() {
    super.initState();
    _logController.startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    return Container(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          StreamBuilder<String>(
              stream: _logController.stream,
              initialData: "Esperando ação...",
              builder: (context, snapshot) {
                print(">>> ${snapshot.data}");
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: Text(
                    snapshot.data,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
              }),
          SizedBox(height: 30),
          Center(
            child: RaisedButton(
              onPressed: _sendData,
              child: const Text("Enviar dados"),
            ),
          ),
        ],
      ),
    );
  }

  void _sendData() {
    _logController.writeData("OLÀ CARAZINHO");
  }
}
