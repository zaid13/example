import 'package:flutter/animation.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';

class BluetoothConnectionsController extends GetxController {
  AnimationController? animationController;

  Rx<bool> isScanning = Rx(false);

  Rx<List<ScanResult>> scanResults = Rx([]);

  scanForDevices() {
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
    scanResults.value = [];
    isScanning.value = true;
    FlutterBlueElves.instance.startScan(5000).listen((scanItem) {
      print(scanItem.macAddress);
      scanResults.value.add(scanItem);

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
    // FlutterBlueElves.instance.stopScan();
  }

  connectToBluetoothDevice(ScanResult scanItem) {
    Device device = scanItem.connect(connectTimeout: 5000);

    ///you can use this device to listen bluetooth device's state
    device.stateStream.listen((newState) {
      ///newState is DeviceState type,include disconnected,disConnecting, connecting,connected, connectTimeout,initiativeDisConnected,destroyed
    }).onDone(() {
      ///if scan timeout or you stop scan,will into this
    });
  }
}
