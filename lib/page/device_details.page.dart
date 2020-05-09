import 'dart:async';

import 'package:controle_bluetooth/bloc/log.bloc.dart';
import 'package:controle_bluetooth/service/bluetooth_device.service.dart';
import 'package:controle_bluetooth/utils/dropdown_temperature.utils.dart';
import 'package:controle_bluetooth/widget/loading_page.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDetails extends StatefulWidget {
  BluetoothDevice device;

  DeviceDetails({this.device});

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  LogController _logController = LogController();
  BluetoothDeviceService _service;
  ScrollController _scrollController = ScrollController();

  int currentTemperature;
  List<DropdownMenuItem<int>> dropdownTemperature;

  BluetoothDevice get device => widget.device;
  bool _ligarAr;

  _updateLog(String msg) {
    _logController.transmit(msg);
  }

  @override
  void initState() {
    // inicializa switch
    _ligarAr = false;

    // inicializa dropdown
    dropdownTemperature = initDropdownTemperature();
    currentTemperature = dropdownTemperature[0].value;

    // inicializa servico de bluetooth
    _service = BluetoothDeviceService(device, _updateLog);
    _service.connectToDevice();
    super.initState();
  }

  @override
  void dispose() {
    print("Deconectando...");
    _logController.dispose();
    _service = null;
    super.dispose();
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalhes de conexão'),
          centerTitle: true,
        ),
        body: StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.disconnected,
          builder: (_, snapshot) {
            if (snapshot.data == BluetoothDeviceState.connected) {
              return _body();
            }
            return LoadingPage(msg: 'Tentando conectar-se ao dispositivo ${device.name}');
          },
        ),
      ),
    );
  }

  Widget _body() {
    // https://medium.com/@DakshHub/flutter-displaying-dynamic-contents-using-listview-builder-f2cedb1a19fb
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Text('Nome'),
                  trailing: Text('${device.name}'),
                ),
                ListTile(
                  leading: Text('MAC'),
                  trailing: Text('${device.id}'),
                ),
                Divider(),
                SwitchListTile.adaptive(
                  title: Text('Ligar ar condicionado'),
                  value: _ligarAr,
                  onChanged: switchTileOnChanged,
                ),
                ListTile(
                  leading: Text('Selecione a temperatura'),
                  trailing: DropdownButton(
                    value: currentTemperature,
                    items: dropdownTemperature,
                    onChanged: _selectTemperature,
                  ),
                )
              ],
            ),
          ),
          _logDisplay()
        ],
      ),
    );
  }

  void switchTileOnChanged(newValue) {
    setState(() {
      _ligarAr = newValue;
    });
    _updateLog('Comando para ligar ar $_ligarAr');
    _service.sendData(_ligarAr.toString());
  }

  _selectTemperature(int newTemperature) {
    setState(() {
      currentTemperature = newTemperature;
    });
    _updateLog('Temperatura selecionada:$currentTemperature');
    _updateLog('Enviando para o servidor');
    _service.sendData(currentTemperature.toString());
  }

  Expanded _logDisplay() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 16.0),
        child: StreamBuilder<List<String>>(
            stream: _logController.stream,
            builder: (context, snapshot) {
              var list = snapshot.data;
              return ListView.builder(
                controller: _scrollController,
                itemCount: list == null ? 0 : list.length,
                itemBuilder: (context, index) {
                  Timer(
                    Duration(seconds: 1),
                        () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
                  );
                  return Text(list[index]);
                },
              );
            }),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
          new AlertDialog(
            title: Text('Tem certeza?'),
            content: Text('Você quer desconectar do dispositivo e voltar para o menu?'),
            actions: <Widget>[
              new FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Não')),
              new FlatButton(
                onPressed: () {
                  _service.disconnectFromDevice();
                  _pop();
                },
                child: Text('Sim'),
              ),
            ],
          ) ??
          false,
    );
  }
}
