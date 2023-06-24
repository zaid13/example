import 'package:ble/constants/style/style.dart';
import 'package:ble/constants/values/values.dart';
import 'package:ble/ui/bluetooth_connections/controller/bluetooth_connections_controller.dart';
import 'package:ble/ui/home/view/home_view.dart';
import 'package:ble/ui/live_data/view/live_data_view.dart';
import 'package:ble/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BluetoothConnectionView extends StatefulWidget {
  BluetoothConnectionView({this.isFirstTime = false, Key? key})
      : super(key: key);

  bool isFirstTime;

  @override
  State<BluetoothConnectionView> createState() =>
      _BluetoothConnectionViewState();
}

class _BluetoothConnectionViewState extends State<BluetoothConnectionView>
    with SingleTickerProviderStateMixin {
  BluetoothConnectionsController controller =
      Get.put(BluetoothConnectionsController());

  @override
  void initState() {
    // TODO: implement initState
    controller.animationController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    controller.isFirstTime = widget.isFirstTime;
    controller.getSavedDeviceAndScanForDevices();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Bluetooth Settings',
          style: TextStyle(color: headingColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: headingColor),
      ),
      drawer: getDrawer(),
      body: Obx(() => Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    controller.savedMacId.value != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Default Device Mac Address: ${controller.savedMacId.value}',
                                        style: TextStyle(color: secondaryColor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Default Device Name: ${controller.savedName.value}',
                                        style: TextStyle(color: secondaryColor),
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      // Text(
                                      //   'Device Connection Status: ${mainDevice == null ? 'NO DEVICE FOUND' : controller.deviceState}',
                                      //   style: TextStyle(color: secondaryColor),
                                      // ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.deleteSavedDeviceData();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: headingColor),
                                  ),
                                )
                              ],
                            ))
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'AVAILABLE DEVICES',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.scanForDevices();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Center(
                                  child: RotationTransition(
                                    turns: Tween(begin: 0.0, end: 1.0).animate(
                                        controller.animationController!),
                                    child: const Icon(
                                      Icons.rotate_left,
                                      color: headingColor,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<BluetoothConnectionsController>(
                        id: "available_bluetooth_devices_view_id",
                        builder: (controller) {
                          return ListView.builder(
                              itemCount: controller.scanResults.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.connectToBluetoothDevice(
                                          controller.scanResults[index]);
                                    },
                                    child: Container(
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Center(
                                          child: Text(
                                            controller
                                                    .scanResults[index].name ??
                                                'Device $index',
                                            style:
                                                TextStyle(color: headingColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
