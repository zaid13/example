import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ble/constants/values/values.dart';
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
  Rx<bool> isFileDataLoading = Rx(false);
  Rx<List<String>> fileData = Rx([]);

  int fileIndex = 0;

  Rx<int> totalFileNumber = Rx(0);
  Rx<int> currentFileNumber = Rx(0);

  resetData() {
    isFileLoading.value = true;
    isFileDataLoading.value = false;
    fileData.value = [];

    fileIndex = 0;

    totalFileNumber.value = 0;
    currentFileNumber.value = 0;
  }

  StreamSubscription<DeviceSignalResult>? deviceSignalResultStream;

  List<BleService> servicesInfo = [];

  List<String> fileList = [];

  void listensToService() {
    try {
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
    } catch (e) {}
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
    Future.delayed(Duration(seconds: 1)).then((value) {
      Uint8List data = Uint8List.fromList([fileIndex]); //32
      print('data: $data');
      device!.writeData(service.serviceUuid, characteristic.uuid, false, data);
      Future.delayed(Duration(seconds: 1)).then((value) {
        device!.readData(serviceUUID, readCharacteristicUUID);
      });
    });
  }

  writeFile(String data, int fileIndex) async {
    var tempPath = await getExternalStorageDirectory();

    String fileFinalPath = '/${fileList[fileIndex].split('\\').last}';

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

  getFileDataPercentage() {
    try {
      if (totalFileNumber.value == 0) return 0;
      return currentFileNumber.value / totalFileNumber.value;
    } catch (e) {
      return 0;
    }
  }

  void listenToIncomingData() {
    try {
      // String data = "";
      String fileNames = "";
      deviceSignalResultStream =
          device!.deviceSignalResultStream.listen((event) async {
        print('new data 22');
        print(event.data);

        if (event.type != DeviceSignalType.characteristicsNotify &&
            event.type != DeviceSignalType.descriptorWrite) {
          if (event.data != null && event.data!.isNotEmpty) {
            if (event.data?.length == 3 && event.data![0] == 32) {
              print('file recieved ');
              // writeFile(bytesBuilder.toBytes());
              // writeFile(data);
              if (fileList.isEmpty && fileIndex == 0) {
                fileList = fileNames.split(',');
                fileList.removeAt(0);
                fileIndex = fileIndex + 2;
                totalFileNumber.value = fileList.length;
                isFileDataLoading.value = true;
                isFileLoading.value = false;
                fileData.value.add("");
                fileData.value.add("");
                callWriteSerivce(
                    selectedService!, selectedWriteCharacteristic!);
              } else if (fileIndex <= fileList.length) {
                fileIndex++;
                currentFileNumber.value++;
                fileData.value.add("");
                callWriteSerivce(
                    selectedService!, selectedWriteCharacteristic!);
              } else {
                fileIndex = 0;
                fileData.value.removeAt(0);
                isFileDataLoading.value = false;
              }
            } else {
              if (fileList.isEmpty && fileIndex == 0) {
                for (int i = 0; i < event.data!.length; i++) {
                  String currentStr = event.data![i].toString();

                  if (currentStr.length < 2) {
                    currentStr = "0$currentStr";
                  }
                  String asciiString =
                      String.fromCharCode(int.parse(currentStr));

                  fileNames = fileNames + asciiString;
                }
                device!.readData(serviceUUID, readCharacteristicUUID);
                // device!.readData(serviceUUID, readCharacteristicUUID);
              } else {
                for (int i = 0; i < event.data!.length; i++) {
                  String currentStr = event.data![i].toString();
                  if (currentStr.length < 2) {
                    currentStr = "0$currentStr";
                  }
                  String asciiString =
                      String.fromCharCode(int.parse(currentStr));

                  fileData.value[fileIndex - 1] =
                      fileData.value[fileIndex - 1] + asciiString;
                }
                device!.readData(serviceUUID, readCharacteristicUUID);
              }
              // bytesBuilder.add(event.data!);
            }
          }
        }
      });
    } catch (e) {}
  }

  // void listenToDeviceState() {
  //   if (mainDevice != null) {
  //     mainDevice!.stateStream.listen((event) {
  //       if (event == DeviceState.connected) {
  //         deviceState = 'Connected';
  //       } else if (event == DeviceState.disconnected) {
  //         deviceState = 'Disconnected';
  //       }
  //     });
  //   }
  // }
}
