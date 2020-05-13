import 'dart:convert';

import 'package:controle_bluetooth/service/communicaton_protocol.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothDeviceService {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";

  CommunicationProtocol _protocol;
  BluetoothCharacteristic _deviceCharacteristic;
  BluetoothDevice _device;
  Function _updateLog;

  BluetoothDeviceService(this._protocol, this._device, this._updateLog);

  connectToDevice() async {
    if (_device == null) {
      _updateLog('Objeto device está nulo');
      return;
    }
//    _changeMTU();
    _updateLog("Conectando....");
    await _device.connect(timeout: Duration(seconds: 10)).catchError((error) {
      print('$error: ${_device.state}');
    });
    discoverServices();
  }

  disconnectFromDevice() {
    if (_device == null) {
      _updateLog('Objeto device está nulo');
      return;
    }
    _device.disconnect();
  }

  discoverServices() async {
    if (_device == null) {
      _updateLog('Objeto device está nulo');
      return;
    }
    _updateLog("Procurando serviços...");
    List<BluetoothService> services = await _device.discoverServices();
    _updateLog("Serviços encontrados");
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        _updateLog('Serviço ${service.uuid.toString()} encontrado');
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            _updateLog('Characteristic ${characteristic.uuid.toString()} encontrada');
            _deviceCharacteristic = characteristic;
          }
        });
      }
    });
    readData();
  }

  readData() async {
    await _deviceCharacteristic.setNotifyValue(true);
    _deviceCharacteristic.value.listen((value) {
      String bytes =  utf8.decode(value);
      _updateLog('Mensagem recebida: $bytes');
    });
  }

  sendData(CommandType type, String data) async {
    if (_device == null) {
      _updateLog('Objeto device está nulo');
      return;
    }
    if(_deviceCharacteristic == null ) {
      _updateLog('Não é possível enviar dados, Characteristic == null');
      return;
    }

    var fmtMessage = _protocol.encode(_device.name, type, data);

    print(data);

    List<int> bytes = utf8.encode(fmtMessage);
    _updateLog('Enviando dados...');
    _updateLog('Mensagem: $fmtMessage');
    print(fmtMessage);
    await _deviceCharacteristic.write(bytes);
    _updateLog('Mensagem enviada');
  }
}
