import 'package:android_intent_plus/android_intent.dart';
import 'package:deneyap/components/button.dart';
import 'package:deneyap/components/info.dart';
import 'package:deneyap/components/textbox.dart';
import 'package:deneyap/controller/bt_controller.dart';
import 'package:deneyap/pages/devices_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BTController());
    final textController = TextEditingController();

    RxString data = ''.obs;

    c.getPermissions();

    final box = GetStorage();
    box.writeIfNull('ports', [
      {'label': 'Oda 1 açık', 'value': '0'},
      {'label': 'Oda 1 kapalı', 'value': '1'},
      {'label': 'Oda 2 açık', 'value': '2'},
      {'label': 'Oda 2 kapalı', 'value': '3'},
      {'label': 'Oda 3 açık', 'value': '4'},
      {'label': 'Oda 3 kapalı', 'value': '5'},
      {'label': 'Kapı açık', 'value': '6'},
      {'label': 'Kapı kapalı', 'value': '7'},
      {'label': 'Pencere açık', 'value': '8'},
      {'label': 'Pencere kapalı', 'value': '9'},
      {'label': 'Hareket var', 'value': 'a'},
      {'label': 'Hareket yok', 'value': 'b'},
      {'label': 'Hava temiz', 'value': 'c'},
      {'label': 'Hava kirlendi', 'value': 'd'},
    ]);

    c.ports.value = box.read('ports');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.webp', height: 28),
                    IconButton(
                      onPressed: () => Get.toNamed('/settings'),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Material(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(15),
                  color: c.isConnected.value
                      ? Colors.blueAccent.shade700
                      : Theme.of(context).colorScheme.background,
                  child: ListTile(
                    onTap: () async => c.isGranted.value
                        ? c.openBluetooth().then((value) {
                            if (value) DevicesList(context);
                          })
                        : await const AndroidIntent(
                            action: 'action_application_details_settings',
                            data: 'package:dev.nodeum.deneyap',
                          ).launch().then((value) => c.getPermissions()),
                    leading: Icon(
                      c.isGranted.value
                          ? c.deviceAddress.value == ''
                              ? Icons.bluetooth_disabled_rounded
                              : c.isConnecting.value
                                  ? Icons.bluetooth_rounded
                                  : Icons.bluetooth_connected_rounded
                          : Icons.warning_rounded,
                    ),
                    title: Text(
                      c.isGranted.value
                          ? c.deviceName.value == ''
                              ? 'Bağlı cihaz yok'
                              : c.deviceName.string
                          : 'İzin Gerekli',
                    ),
                    subtitle: Text(
                      c.isGranted.value
                          ? c.deviceAddress.value == ''
                              ? 'Cihaz seçin'
                              : c.deviceAddress.string
                          : 'Lütfen tüm izinleri verin',
                    ),
                    trailing: const Icon(Icons.unfold_more_rounded),
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: !c.isConnected.value
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/lost.webp',
                              width: 350,
                            ),
                            const Text(
                              "Bağlı Bluetooth Cihazı Yok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const Text(
                              "Kontroller için bir cihaza bağlanın",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(width: double.infinity, height: 100)
                          ],
                        )
                      : ListView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Led'),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 120,
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Button(
                                        label: 'Oda 1',
                                        icon: Icons.flourescent_rounded,
                                        state: false,
                                        activeColor: Colors.red.shade700,
                                        onChanged: (value) => c.sendData(value
                                            ? c.ports[0]['value']
                                            : c.ports[1]['value']),
                                      ),
                                      const SizedBox(width: 15),
                                      Button(
                                        label: 'Oda 2',
                                        icon: Icons.flourescent_rounded,
                                        state: false,
                                        activeColor: Colors.amber.shade700,
                                        onChanged: (value) => c.sendData(value
                                            ? c.ports[2]['value']
                                            : c.ports[3]['value']),
                                      ),
                                      const SizedBox(width: 15),
                                      Button(
                                        label: 'Oda 3',
                                        icon: Icons.flourescent_rounded,
                                        state: false,
                                        activeColor: Colors.blue.shade800,
                                        onChanged: (value) => c.sendData(value
                                            ? c.ports[4]['value']
                                            : c.ports[5]['value']),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25),
                                const Text('Servo'),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Button(
                                        label: 'Kapı',
                                        icon: Icons.meeting_room_outlined,
                                        state: false,
                                        activeColor: Colors.orange.shade800,
                                        onChanged: (value) => c.sendData(value
                                            ? c.ports[6]['value']
                                            : c.ports[7]['value']),
                                      ),
                                      const SizedBox(width: 15),
                                      Button(
                                        label: 'Pencere',
                                        icon: Icons.door_sliding_outlined,
                                        state: false,
                                        activeColor: Colors.deepOrange,
                                        onChanged: (value) => c.sendData(value
                                            ? c.ports[8]['value']
                                            : c.ports[9]['value']),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25),
                                const Text('Hareket ve Gaz'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Info(
                                        icon: Icons.directions_run_rounded,
                                        label: c.motion.value
                                            ? 'Hareket var'
                                            : 'Hareket yok',
                                        state: c.motion.value,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Info(
                                        icon: Icons.air_rounded,
                                        label: c.gas.value
                                            ? 'Hava kirlendi'
                                            : 'Hava temiz',
                                        state: c.gas.value,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                const Text('Gelen Mesaj'),
                                const SizedBox(height: 10),
                                Obx(() => Info(
                                      icon: Icons.code_rounded,
                                      label: c.message.string,
                                      state: false,
                                    )),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      '* Bingöl Deneyap Teknoloji Atölyesi Tarafından Geliştirildi',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                ),
                if (c.isConnected.value)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Textbox(
                            onChanged: (value) => data.value = value,
                            hint: 'Veri gönder',
                            controller: textController,
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            if (data.value.trim() != '') {
                              c.sendData(data.value.trim());
                              textController.clear();
                              data.value = '';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'GÖNDER',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
