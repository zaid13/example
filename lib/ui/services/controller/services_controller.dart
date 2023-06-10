import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';

class ServicesController extends GetxController {
  Device? device;
  Rx<List<BleService>> servicesInfo = Rx([]);
  final TextEditingController sendDataTextController = TextEditingController();

  void listensToService() {
    ///use this stream to listen discovery result
    device!.serviceDiscoveryStream.listen((serviceItem) {
      servicesInfo.value.add(serviceItem);
    });
    device!.discoveryService();
  }

  String getServiceName(BleService value) {
    String serviceTitle = "Unknow Service";
    if (Platform.isAndroid) {
      switch (value.serviceUuid.substring(4, 8)) {
        case "1800":
          serviceTitle = "Generic Access";
          break;
        case "1801":
          serviceTitle = "Generic Attribute";
          break;
      }
    }
    return serviceTitle;
  }

  Future<void> callWriteSerivce(
      BleService value, BleCharacteristic characteristic) async {
    if (device!.state != DeviceState.connected) {
      device!.connect(connectTimeout: 10000);
      await Future.delayed(Duration(seconds: 1), () {});
    }

    writeFunction(value, characteristic);
  }

  writeFunction(BleService service, BleCharacteristic characteristic) async {
    Uint8List data = Uint8List.fromList([23, 44]); //32
    print('data: $data');
    String fileString = '';
    device!.writeData(service.serviceUuid, characteristic.uuid, false, data);
  }

  readFunction(
    BleService service,
  ) async {
    print("reading");

    device!
        .readData(service.serviceUuid, '586870fd-4a57-4eef-9c73-c1e65b4dd86e');
  }
}
