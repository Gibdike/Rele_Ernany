import 'dart:async';
import 'dart:convert';

import 'package:controle_bluetooth/bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

class LogController extends Bloc<String> {

  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String TARGET_DEVICE_NAME = "ESP32";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  @override
  add(String object) {
    streamController.add(object);
  }

  @override
  addError(Object error) {
    streamController.addError(error);
  }

  @override
  Stream get stream => streamController.stream;

  startScan() {
    scanSubscription = flutterBlue.scan(timeout: Duration(seconds: 5)).listen((scanResult) {
      print("NOME: ${scanResult.device.name}");
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        stopScan();
        add("O dispositivo ${scanResult.device.name} foi encontrado");
        print(">>> ${scanResult.device.toString()}");
        print(">>> ${scanResult.device.id}");
        print(">>> ${scanResult.advertisementData.toString()}");
        print(">>> ${scanResult.rssi}");
        targetDevice = scanResult.device;
        connectToDevice();
      }
    });
  }

  connectToDevice() async {
    if (targetDevice == null) return;
    add("Conectando ao dispositivo ${targetDevice.name}...");
    await targetDevice.connect();
    add("dispositivo ${targetDevice.name} conectado!");
    discoverServices();
  }

  stopScan() {
    scanSubscription?.cancel();
    scanSubscription = null;
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;
    targetDevice.disconnect();
    add("Dispositivo ${targetDevice.name} foi desconectado");
    print("Dispositivo ${targetDevice.name} foi desconectado");
  }

  discoverServices() async {
    if (targetDevice == null) return;
    final services = await targetDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            add("Servicos do dispositivo ${targetDevice.name} estão pronto!");
            print("Servicos do dispositivo ${targetDevice.name} estão pronto!");
          }
        });
      }
    });
  }

  writeData(String data) async {
    if (targetDevice == null) return;
    List<int> bytes = utf8.encode(data);
    add("Enviando dados...");
    print("Enviando dados...");
    await targetCharacteristic.write(bytes);
    print("Dados enviados para dispositivo ${targetDevice.name}");
    add("Dados enviados para dispositivo ${targetDevice.name}");
  }
}
