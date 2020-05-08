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

  startScan() {
    scanSubscription = flutterBlue.scan().listen((scanResult) {
      print("NOME: ${scanResult.device.name}");
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        stopScan();
        add("O dispositivo ${scanResult.device.name} foi encontrado");
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
    if(targetDevice == null ) return;
    targetDevice.disconnect();
    add("Dispositivo ${targetDevice.name} foi desconectado");
    print("Dispositivo ${targetDevice.name} foi desconectado");
  }

  discoverServices() async {
    if(targetDevice == null ) return;
    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if(service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic){
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
    if(targetDevice == null) return;
    List<int> bytes = utf8.encode(data);
    add("Enviando dados...");
    print("Enviando dados...");
    await targetCharacteristic.write(bytes);
    print("Dados enviados para dispositivo ${targetDevice.name}");
    add("Dados enviados para dispositivo ${targetDevice.name}");
  }
}