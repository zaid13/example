import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LiveDataController extends GetxController {
  StreamSubscription<DeviceSignalResult>? deviceSignalResultStream;

  Device? device;
  String serviceUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86a';
  String readCharacteristicUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86b';
  String writeCharacteristicUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86c';
  String notifyCharacteristicUUID = '586870fd-4a57-4eef-9c73-c1e65b4dd86d';

  BleService? selectedService;
  BleCharacteristic? selectedNotifyCharacteristic;

  Rx<List<double>> diffPressure = Rx([]);
  Rx<List<double>> ductTemp = Rx([]);
  Rx<List<double>> flowRate = Rx([]);
  Rx<List<double>> isoKineticTemp = Rx([]);

  Rx<int> chartDataIndex = Rx(0);

  Rx<List<String>> completeLiveData = Rx([]);

  DateTime updateTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  void resetChartsData() {
    diffPressure.value = [];
    ductTemp.value = [];
    flowRate.value = [];
    isoKineticTemp.value = [];
    chartDataIndex.value = 0;
    updateTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  }

  void addChartsData() {
    if (chartDataIndex.value < 10) {
      if (completeLiveData.value.asMap().containsKey(4)) {
        diffPressure.value.add(double.parse(completeLiveData.value[4]));
      } else {
        diffPressure.value.add(0);
      }
      if (completeLiveData.value.asMap().containsKey(7)) {
        ductTemp.value.add(double.parse(completeLiveData.value[7]));
      } else {
        ductTemp.value.add(0);
      }

      if (completeLiveData.value.asMap().containsKey(3)) {
        flowRate.value.add(double.parse(completeLiveData.value[3]));
      } else {
        flowRate.value.add(0);
      }

      if (completeLiveData.value.asMap().containsKey(8)) {
        isoKineticTemp.value.add(double.parse(completeLiveData.value[8]));
      } else {
        isoKineticTemp.value.add(0);
      }
    } else {
      if (completeLiveData.value.asMap().containsKey(4)) {
        diffPressure.value.removeAt(0);
        diffPressure.value.add(double.parse(completeLiveData.value[4]));
        // diffPressure.value[chartDataIndex.value % 20] =
        //     double.parse(completeLiveData.value[4]);
      } else {
        diffPressure.value.removeAt(0);
        diffPressure.value.add(0.0);
        // diffPressure.value[chartDataIndex.value % 20] = 0;
      }
      if (completeLiveData.value.asMap().containsKey(7)) {
        ductTemp.value.removeAt(0);
        ductTemp.value.add(double.parse(completeLiveData.value[7]));
        // ductTemp.value[chartDataIndex.value % 20] =
        //     double.parse(completeLiveData.value[7]);
      } else {
        ductTemp.value.removeAt(0);
        ductTemp.value.add(0.0);
        // ductTemp.value[chartDataIndex.value % 20] = 0;
      }

      if (completeLiveData.value.asMap().containsKey(3)) {
        flowRate.value.removeAt(0);
        flowRate.value.add(double.parse(completeLiveData.value[3]));
        // flowRate.value[chartDataIndex.value % 20] =
        //     double.parse(completeLiveData.value[3]);
      } else {
        flowRate.value.removeAt(0);
        flowRate.value.add(0.0);
        // flowRate.value[chartDataIndex.value % 20] = 0;
      }

      if (completeLiveData.value.asMap().containsKey(8)) {
        isoKineticTemp.value.removeAt(0);
        isoKineticTemp.value.add(double.parse(completeLiveData.value[8]));
        // isoKineticTemp.value[chartDataIndex.value % 20] =
        //     double.parse(completeLiveData.value[8]) ;
      } else {
        isoKineticTemp.value.removeAt(0);
        isoKineticTemp.value.add(0.0);
        // isoKineticTemp.value[chartDataIndex.value % 20] = 0;
      }
    }
    chartDataIndex.value++;
    updateTime = DateTime.now();
    update(['live_data_first_chart_view_id', 'live_data_second_chart_view_id']);
  }

  void listensToService() {
    ///use this stream to listen discovery result
    try {
      device!.serviceDiscoveryStream.listen((serviceItem) {
        if (serviceItem.serviceUuid == serviceUUID) {
          serviceItem.characteristics.forEach((characteristic) {
            if (characteristic.uuid == notifyCharacteristicUUID) {
              selectedService = serviceItem;
              selectedNotifyCharacteristic = characteristic;
              device!.setNotify(serviceUUID, characteristic.uuid, true);
            }
          });
        }
      });
      device!.discoveryService();
    } catch (e) {}
  }

  void listenToIncomingData() {
    try {
      String data = "";
      deviceSignalResultStream =
          device!.deviceSignalResultStream.listen((event) async {
        print('new data 22');
        // print(event.data);

        // String? data;
        // List<int> bytes = [];
        // List<Uint8List> data = [];
        // BytesBuilder bytesBuilder = BytesBuilder();
        if (event.type == DeviceSignalType.characteristicsNotify) {
          for (int i = 0; i < event.data!.length; i++) {
            String currentStr = event.data![i].toString();

            if (currentStr.length < 2) {
              currentStr = "0" + currentStr;
            }
            String asciiString = String.fromCharCode(int.parse(currentStr));

            data = data + asciiString;
          }
          completeLiveData.value = [];
          List<String> splitedData = data.split('\r\n');
          completeLiveData.value =
              splitedData[splitedData.length >= 2 ? splitedData.length - 2 : 0]
                  .split('#');
          addChartsData();
          // completeLiveData.value = data.split('\r\n').last.split('#');
          print(
              'ng data ${splitedData[splitedData.length >= 2 ? splitedData.length - 2 : 0]}');
        }

        // if (event.type == DeviceSignalType.characteristicsRead ||
        //     event.type == DeviceSignalType.unKnown) {
        //   print('read descriptor unknown');
        //   print('data: $data');
        //
        //   print(event.uuid +
        //       "\n" +
        //       (event.isSuccess
        //           ? "read data success signal and data:\n"
        //           : "read data failed signal and data:\n") +
        //       (data.toString() ?? "none") +
        //       "\n" +
        //       DateTime.now().toString());
        //   // setState(() {
        //   //   _logs.insert(
        //   //       0,
        //   //       _LogItem(
        //   //           event.uuid,
        //   //           (event.isSuccess
        //   //                   ? "read data success signal and data:\n"
        //   //                   : "read data failed signal and data:\n") +
        //   //               (data ?? "none"),
        //   //           DateTime.now().toString()));
        //   // });
        // } else if (event.type == DeviceSignalType.characteristicsWrite) {
        //   print(event.uuid +
        //       "\n" +
        //       (event.isSuccess
        //           ? "write data success signal and data:\n"
        //           : "write data success signal and data:\n") +
        //       (data.toString() ?? "none") +
        //       "\n" +
        //       DateTime.now().toString());
        //   // setState(() {
        //   //
        //   //   _logs.insert(
        //   //       0,
        //   //       _LogItem(
        //   //           event.uuid,
        //   //           (event.isSuccess
        //   //                   ? "write data success signal and data:\n"
        //   //                   : "write data success signal and data:\n") +
        //   //               (data ?? "none"),
        //   //           DateTime.now().toString()));
        //   // });
        // } else if (event.type == DeviceSignalType.characteristicsNotify) {
        //   print(event.uuid +
        //       "\n" +
        //       (data.toString() ?? "none") +
        //       "\n" +
        //       DateTime.now().toString());
        //   // setState(() {
        //   //   _logs.insert(0,
        //   //       _LogItem(event.uuid, data ?? "none", DateTime.now().toString()));
        //   // });
        // } else if (event.type == DeviceSignalType.descriptorRead) {
        //   print('read descriptor -3');
        //   print(event.uuid +
        //       "\n" +
        //       (event.isSuccess
        //           ? "success\n"
        //           : "read descriptor data failed signal and data:\n") +
        //       (data.toString() ?? "none") +
        //       "\n" +
        //       DateTime.now().toString());
        //   // setState(() {
        //   //   print('data');
        //   //   print(data);
        //   //   print('data');
        //   //
        //   //   _logs.insert(
        //   //       0,
        //   //       _LogItem(
        //   //           event.uuid,
        //   //           (event.isSuccess
        //   //                   ? "success\n"
        //   //                   : "read descriptor data failed signal and data:\n") +
        //   //               (data ?? "none"),
        //   //           DateTime.now().toString()));
        //   // });
        // }
      });
    } catch (e) {}
  }

  getProgramStatus() {
    if (completeLiveData.value.asMap().containsKey(0)) {
      if (completeLiveData.value[0] == "0") {
        return 'OFF';
      } else if (completeLiveData.value[0] == "1") {
        return 'SAMPLING';
      } else if (completeLiveData.value[0] == "2") {
        return 'INSPECTION';
      } else {
        return 'UNKNOWN';
      }
    } else {
      return 'N/A';
    }
  }

  getPumpStatus() {
    if (completeLiveData.value.asMap().containsKey(1)) {
      if (completeLiveData.value[1] == "0") {
        return 'OFF';
      } else if (completeLiveData.value[1] == "1") {
        return 'ON';
      } else {
        return 'UNKNOWN';
      }
    } else {
      return 'N/A';
    }
  }

  getPressureUnit() {
    if (completeLiveData.value.asMap().containsKey(2)) {
      if (completeLiveData.value[2] == "0") {
        return 'mmH2O';
      } else if (completeLiveData.value[2] == "1") {
        return 'Pa';
      } else {
        return 'UNKNOWN';
      }
    } else {
      return 'N/A';
    }
  }

  getSetFlowValue() {
    if (completeLiveData.value.asMap().containsKey(3)) {
      return completeLiveData.value[3];
    } else {
      return 'N/A';
    }
  }

  getDiffPressureValue() {
    if (completeLiveData.value.asMap().containsKey(4)) {
      return completeLiveData.value[4];
    } else {
      return 'N/A';
    }
  }

  getStaticPressureValue() {
    if (completeLiveData.value.asMap().containsKey(5)) {
      return completeLiveData.value[5];
    } else {
      return 'N/A';
    }
  }

  getBaroMetricPressureValue() {
    if (completeLiveData.value.asMap().containsKey(6)) {
      return completeLiveData.value[6];
    } else {
      return 'N/A';
    }
  }

  getDuctTempValue() {
    if (completeLiveData.value.asMap().containsKey(7)) {
      return completeLiveData.value[7];
    } else {
      return 'N/A';
    }
  }

  getISOKineticValue() {
    if (completeLiveData.value.asMap().containsKey(8)) {
      return completeLiveData.value[8];
    } else {
      return 'N/A';
    }
  }

  getPointDoneByTotal() {
    if (completeLiveData.value.asMap().containsKey(9)) {
      return completeLiveData.value[9];
    } else {
      return 'N/A';
    }
  }

  getElapsedTimeInMints() {
    if (completeLiveData.value.asMap().containsKey(10)) {
      return completeLiveData.value[10];
    } else {
      return 'N/A';
    }
  }

  getSetPointTimeInMints() {
    if (completeLiveData.value.asMap().containsKey(11)) {
      return completeLiveData.value[11];
    } else {
      return 'N/A';
    }
  }

  getRemainingTimeInMints() {
    if (completeLiveData.value.asMap().containsKey(12)) {
      return completeLiveData.value[12];
    } else {
      return 'N/A';
    }
  }

  String getAxis() {
    if (completeLiveData.value.asMap().containsKey(13)) {
      return completeLiveData.value[13];
    } else {
      return 'N/A';
    }
  }

  getVelocity() {
    if (completeLiveData.value.asMap().containsKey(14)) {
      return completeLiveData.value[14];
    } else {
      return 'N/A';
    }
  }

  getDateTime() {
    return DateFormat('HH:mm').format(updateTime);
    // return updateTime.
    if (completeLiveData.value.asMap().containsKey(14)) {
      return completeLiveData.value[14];
    } else {
      return 'N/A';
    }
  }

  getPumpStatusColor() {
    if (completeLiveData.value.asMap().containsKey(1)) {
      if (completeLiveData.value[1] == "0") {
        return Colors.red;
      } else if (completeLiveData.value[1] == "1") {
        return Colors.green;
      }
    }

    return null;
  }
}
