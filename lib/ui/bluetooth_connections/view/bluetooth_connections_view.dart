import 'package:ble/constants/style/style.dart';
import 'package:ble/ui/bluetooth_connections/controller/bluetooth_connections_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BluetoothConnectionView extends StatefulWidget {
  const BluetoothConnectionView({Key? key}) : super(key: key);

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

    controller.scanForDevices();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Bluetooth',
          style: TextStyle(color: headingColor),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.settings,
                color: headingColor,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(),
          ),
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
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(controller.animationController!),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  controller.scanResults[index].name ??
                                      'Device $index',
                                  style: TextStyle(color: headingColor),
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
    );
  }
}
