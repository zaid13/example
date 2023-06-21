import 'package:ble/ui/home/view/home_view.dart';
import 'package:ble/ui/live_data/view/live_data_view.dart';
import 'package:ble/ui/services/view/services_view.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class BluetoothConnectionsController extends GetxController {
  AnimationController? animationController;

  Rx<bool> isScanning = Rx(false);
  Rx<bool> locationServiceEnabled = Rx(false);

  List<ScanResult> scanResults = [];

  scanForDevices() async {
    if (await Permission.location.request().isGranted)
    // Either the permission was already granted before or the user just granted it.
    {
      Location location = Location();
      locationServiceEnabled.value = await location.serviceEnabled();
      if (!locationServiceEnabled.value) {
        locationServiceEnabled.value = await location.requestService();
        if (locationServiceEnabled.value) {
          scanningDevices();
        }
      } else {
        scanningDevices();
      }
    }
  }

  scanningDevices() {
    animationController!.repeat();
    FlutterBlueElves.instance.androidApplyBluetoothPermission((isOk) {
      print(isOk
          ? "The user agrees to turn on the Bluetooth permission"
          : "The user does not agrees to turn on the Bluetooth permission");
    });

    ///turn on bluetooth function
    FlutterBlueElves.instance.androidOpenBluetoothService((isOk) {
      print(isOk
          ? "The user agrees to turn on the Bluetooth function"
          : "The user does not agrees to turn on the Bluetooth function");
    });
    scanResults = [];
    isScanning.value = true;
    FlutterBlueElves.instance.startScan(5000).listen((scanItem) {
      print(scanItem.macAddress);
      scanResults.add(scanItem);
      if (scanItem.name == 'WINDOW10') {
        connectToBluetoothDevice(scanItem);
      }
      update(['available_bluetooth_devices_view_id']);

      print(scanItem.uuids);
      print(scanItem.name ?? 'device');

      ///Use the information in the scanned object to filter the devices you want
      ///if want to connect someone,call scanItem.connect,it will return Device object
      // Device device = scanItem.connect(connectTimeout: 5000);
      ///you can use this device to listen bluetooth device's state
      // device.stateStream.listen((newState){
      //   ///newState is DeviceState type,include disconnected,disConnecting, connecting,connected, connectTimeout,initiativeDisConnected,destroyed
      // }).onDone(() {
      //   ///if scan timeout or you stop scan,will into this
      // });
    });
    animationController!.stop();
    // isScanning.value = false;
    //
    // ///stop scan
    // FlutterBlueElves.instance.stopScan();}
  }

  connectToBluetoothDevice(ScanResult scanItem) {
    Device device = scanItem.connect(connectTimeout: 5000);

    device.stateStream.listen((event) {
      if (event == DeviceState.connected) {
        Get.to(LiveDataView(
          device: device,
        ));
        // Get.to(HomeView(
        //   device: device,
        // ));
      }
    });

    // ///you can use this device to listen bluetooth device's state
    // device.stateStream.listen((newState) {
    //   ///newState is DeviceState type,include disconnected,disConnecting, connecting,connected, connectTimeout,initiativeDisConnected,destroyed
    // }).onDone(() {
    //   ///if scan timeout or you stop scan,will into this
    // });]
    // if (device.state == DeviceState.connected) {
    //   Get.to(ServicesView(
    //     device: device,
    //   ));
    // }
  }
}
