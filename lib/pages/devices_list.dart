import 'package:deneyap/controller/bt_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class DevicesList {
  DevicesList(BuildContext context) {
    final c = Get.put(BTController());
    c.getDevices();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Colors.red,
      builder: (context) {
        return Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cihaz seçin',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (context, index) => Obx(
                    () {
                      BluetoothDevice device = c.devices[index];
                      return ListTile(
                        onTap: c.isConnecting.value
                            ? null
                            : () => c.connection(device),
                        leading: Icon(
                          c.deviceAddress.value == device.address &&
                                  !c.isConnecting.value
                              ? Icons.bluetooth_connected_rounded
                              : Icons.bluetooth_rounded,
                        ),
                        title: Text(device.name ?? '-'),
                        subtitle: Text(device.address),
                        trailing: c.deviceAddress.value == device.address &&
                                c.isConnecting.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                c.deviceAddress.value == device.address
                                    ? Icons.check_circle_rounded
                                    : Icons.navigate_next_rounded,
                              ),
                      );
                    },
                  ),
                  itemCount: c.devices.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  '* Bluetooth cihazınızı listede göremiyor musunuz? Bluetooth ayarlarından cihazınıza bağlanıp tekrar deneyin',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: () {
                    c.openBluetoothSettings();
                    Get.back();
                  },
                  focusNode: FocusNode(skipTraversal: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'BLUETOOTH AYARLARINI AÇ',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
