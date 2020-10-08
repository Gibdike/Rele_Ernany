import 'package:controle_bluetooth/page/device_details.page.dart';
import 'package:controle_bluetooth/utils/nav.utils.dart';
import 'package:controle_bluetooth/widget/device_list.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 3));
    super.initState();
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
          title: Text("Controle do Relé"),
        ),
        body: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (_, snapshot) {
            return snapshot.data
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _body();
          },
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                tooltip: 'Parar',
                child: Icon(Icons.stop),
                backgroundColor: Colors.red,
                onPressed: () => FlutterBlue.instance.stopScan(),
              );
            } else {
              return FloatingActionButton(
                tooltip: 'Atualizar',
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)),
              );
            }
          },
        ));
  }

  _body() {
    return RefreshIndicator(
      onRefresh: () =>
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 3)),
      child: ListView(children: <Widget>[_deviceList()]),
    );
  }

  Widget _deviceList() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: [],
            builder: (c, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data
                      .map((data) => DeviceList(
                            data: data,
                            onTap: () => push(
                              context,
                              DeviceDetails(device: data.device),
                            ),
                          ))
                      .toList(),
                );
              }
              return Center(
                  child: Text(
                'Nenhum dispositivo encontrado',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ));
            },
          ),
        ],
      ),
    );
  }
}
