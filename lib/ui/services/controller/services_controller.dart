import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ble/ui/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ServicesController extends GetxController {
  Device? device;
  List<BleService> servicesInfo = [];
  final TextEditingController sendDataTextController = TextEditingController();
  StreamSubscription<DeviceSignalResult>? deviceSignalResultStream;

  BleService? selectedService;

  BleCharacteristic? selectedCharacteristic;

  void listensToService() {
    ///use this stream to listen discovery result
    device!.serviceDiscoveryStream.listen((serviceItem) {
      servicesInfo.add(serviceItem);
      update(['available_services_view_id']);
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

    Get.to(HomeView(
      device: device!,
    ));
  }

  // writeFile(Uint8List data)
  writeFile(String data) async {
    var tempPath = await getExternalStorageDirectory();

    String filePath = tempPath!.path + '/file1.csv';
    final file = File(filePath);
    print('file data ${data.toString()}');
    file.writeAsStringSync(data);
    //file.writeAsString('bytes');
    // Write the file
    print("file store in ${file.path}");
  }

  void listenToIncomingData() {
    String data = "";
    deviceSignalResultStream =
        device!.deviceSignalResultStream.listen((event) async {
      print('new data 22');
      print(event.data);

      // String? data;
      // List<int> bytes = [];
      // List<Uint8List> data = [];
      // BytesBuilder bytesBuilder = BytesBuilder();

      if (event.data != null && event.data!.isNotEmpty) {
        if (event.data?.length == 1 && event.data![0] == 32) {
          print('file recieved ');
          // writeFile(bytesBuilder.toBytes());
          writeFile(data);
        } else {
          for (int i = 0; i < event.data!.length; i++) {
            String currentStr = event.data![i].toString();

            if (currentStr.length < 2) {
              currentStr = "0" + currentStr;
            }
            String asciiString = String.fromCharCode(int.parse(currentStr));

            data = data + asciiString;
          }
          if (selectedService != null && selectedCharacteristic != null) {
            device!.readData(
                selectedService!.serviceUuid, selectedCharacteristic!.uuid);
          }
          // bytesBuilder.add(event.data!);
        }
      }

      if (event.type == DeviceSignalType.characteristicsRead ||
          event.type == DeviceSignalType.unKnown) {
        print('read descriptor unknown');
        print('data: $data');

        print(event.uuid +
            "\n" +
            (event.isSuccess
                ? "read data success signal and data:\n"
                : "read data failed signal and data:\n") +
            (data.toString() ?? "none") +
            "\n" +
            DateTime.now().toString());
        // setState(() {
        //   _logs.insert(
        //       0,
        //       _LogItem(
        //           event.uuid,
        //           (event.isSuccess
        //                   ? "read data success signal and data:\n"
        //                   : "read data failed signal and data:\n") +
        //               (data ?? "none"),
        //           DateTime.now().toString()));
        // });
      } else if (event.type == DeviceSignalType.characteristicsWrite) {
        print(event.uuid +
            "\n" +
            (event.isSuccess
                ? "write data success signal and data:\n"
                : "write data success signal and data:\n") +
            (data.toString() ?? "none") +
            "\n" +
            DateTime.now().toString());
        // setState(() {
        //
        //   _logs.insert(
        //       0,
        //       _LogItem(
        //           event.uuid,
        //           (event.isSuccess
        //                   ? "write data success signal and data:\n"
        //                   : "write data success signal and data:\n") +
        //               (data ?? "none"),
        //           DateTime.now().toString()));
        // });
      } else if (event.type == DeviceSignalType.characteristicsNotify) {
        print(event.uuid +
            "\n" +
            (data.toString() ?? "none") +
            "\n" +
            DateTime.now().toString());
        // setState(() {
        //   _logs.insert(0,
        //       _LogItem(event.uuid, data ?? "none", DateTime.now().toString()));
        // });
      } else if (event.type == DeviceSignalType.descriptorRead) {
        print('read descriptor -3');
        print(event.uuid +
            "\n" +
            (event.isSuccess
                ? "success\n"
                : "read descriptor data failed signal and data:\n") +
            (data.toString() ?? "none") +
            "\n" +
            DateTime.now().toString());
        // setState(() {
        //   print('data');
        //   print(data);
        //   print('data');
        //
        //   _logs.insert(
        //       0,
        //       _LogItem(
        //           event.uuid,
        //           (event.isSuccess
        //                   ? "success\n"
        //                   : "read descriptor data failed signal and data:\n") +
        //               (data ?? "none"),
        //           DateTime.now().toString()));
        // });
      }
    });
  }
}
