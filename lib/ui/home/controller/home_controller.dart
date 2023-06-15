import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  Rx<int> currentLoadingFile = Rx(1);
  Rx<bool> isMainFolderSeleceted = Rx(false);
  Rx<int> mainSelectedFolder = Rx(1);
  Rx<bool> isSubFolderSelected = Rx(false);
  Rx<int> subSelectedFolder = Rx(1);

  Device? device;
  String serviceUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86a';
  String readCharacteristicUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86b';
  String writeCharacteristicUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86c';

  BleCharacteristic? selectedWriteCharacteristic;
  BleService? selectedService;

  Rx<bool> isFileLoading = Rx(true);
  Rx<List<String>> fileData = Rx([]);

  int fileIndex = 0;

  StreamSubscription<DeviceSignalResult>? deviceSignalResultStream;

  List<BleService> servicesInfo = [];

  void listensToService() {
    ///use this stream to listen discovery result
    device!.serviceDiscoveryStream.listen((serviceItem) {
      if (serviceItem.serviceUuid == serviceUUID) {
        serviceItem.characteristics.forEach((characteristic) {
          if (characteristic.uuid == writeCharacteristicUUID) {
            selectedService = serviceItem;
            selectedWriteCharacteristic = characteristic;
            callWriteSerivce(serviceItem, characteristic);
          }
        });
      }
    });
    device!.discoveryService();
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
    Uint8List data = Uint8List.fromList([fileIndex + 1]); //32
    print('data: $data');
    device!.writeData(service.serviceUuid, characteristic.uuid, false, data);
    Future.delayed(Duration(seconds: 2)).then((value) {
      device!.readData(serviceUUID, readCharacteristicUUID);
    });
  }

  writeFile(String data, int fileIndex) async {
    var tempPath = await getExternalStorageDirectory();

    String fileFinalPath = '/file$fileIndex.csv';

    String filePath = tempPath!.path + fileFinalPath;
    final file = File(filePath);
    print('file data ${data.toString()}');
    file.writeAsStringSync(data);
    //file.writeAsString('bytes');
    // Write the file
    print("file store in ${file.path}");
    Get.showSnackbar(GetSnackBar(
      title: 'Completed',
      message: 'File has been saved',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
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
          // writeFile(data);
          fileData.value.add(data);
          if (fileIndex < 5) {
            callWriteSerivce(selectedService!, selectedWriteCharacteristic!);
            fileIndex++;
          } else {
            fileIndex = 0;
            isFileLoading.value = false;
          }
        } else {
          for (int i = 0; i < event.data!.length; i++) {
            String currentStr = event.data![i].toString();

            if (currentStr.length < 2) {
              currentStr = "0" + currentStr;
            }
            String asciiString = String.fromCharCode(int.parse(currentStr));

            data = data + asciiString;
          }

          device!.readData(serviceUUID, readCharacteristicUUID);

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
