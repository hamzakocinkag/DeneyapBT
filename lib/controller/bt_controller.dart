import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BTController extends GetxController {
  final FlutterBluetoothSerial _bt = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;

  RxList ports = [].obs;

  RxString deviceName = ''.obs;
  RxString deviceAddress = ''.obs;
  RxString message = ''.obs;

  RxBool isGranted = false.obs;
  RxBool isConnecting = false.obs;
  RxBool isConnected = false.obs;

  RxBool motion = false.obs;
  RxBool gas = false.obs;

  RxList devices = [].obs;

  Future getPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        if (await Permission.location.request().isGranted) {
          return isGranted.value = true;
        }
      }
    }
    isGranted.value = false;
  }

  Future<bool> openBluetooth() async => await _bt.requestEnable() ?? false;

  void openBluetoothSettings() => _bt.openSettings();

  Future getDevices() async => devices.value = await _bt.getBondedDevices();

  void _disconnect() {
    isConnected.value = false;
    isConnecting.value = false;
    deviceName.value = '';
    deviceAddress.value = '';
    motion.value = false;
    gas.value = false;
  }

  Future connection(BluetoothDevice device) async {
    deviceName.value = device.name ?? '-';
    deviceAddress.value = device.address;

    isConnected.value = false;
    isConnecting.value = true;

    try {
      _connection = await BluetoothConnection.toAddress(device.address);

      isConnected.value = true;
      isConnecting.value = false;

      _connection!.input!.listen((Uint8List data) {
        final String trim = utf8.decode(data).trim().replaceAll('\n', ' ');
        if (trim.isNotEmpty) {
          if (trim == ports[10]['value']) {
            motion.value = true;
          } else if (trim == ports[11]['value']) {
            motion.value = false;
          } else if (trim == ports[12]['value']) {
            gas.value = true;
          } else if (trim == ports[13]['value']) {
            gas.value = false;
          } else {
            message.value = trim;
          }
        }
      }).onDone(() => _disconnect());

      Get.back();
    } catch (e) {
      _disconnect();
    }
  }

  void sendData(String data) {
    if (_connection != null && isConnected.value) {
      _connection!.output.add(Uint8List.fromList(utf8.encode(data)));
      _connection!.output.allSent;
    }
  }
}
