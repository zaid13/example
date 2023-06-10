import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:ble/ui/services/controller/services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';

class ServicesView extends StatefulWidget {
  ServicesView({required this.device, Key? key}) : super(key: key);

  Device device;

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  ServicesController controller = Get.put(ServicesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.device = widget.device;
    controller.listensToService();
    controller.listenToIncomingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.servicesInfo.value.length,
            itemBuilder: (context, index) {
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.getServiceName(
                            controller.servicesInfo.value[index]),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.servicesInfo.value[index].serviceUuid,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: controller
                            .servicesInfo.value[index].characteristics
                            .map((characteristic) {
                          if ('586870fd-4a57-4eef-9c73-c1e65b4dd86e' ==
                              characteristic.uuid) {
                            // readService = characteristic;
                          }
                          String properties = "";
                          List<ElevatedButton> buttons = [];
                          if (characteristic.properties
                              .contains(CharacteristicProperties.read)) {
                            print('characteristic.uuid');
                            print(characteristic.uuid);

                            buttons.add(ElevatedButton(
                              onPressed: () async {
                                print("reading");
                                controller.device!.readData(
                                    controller
                                        .servicesInfo.value[index].serviceUuid,
                                    characteristic.uuid);
                              },
                              child: const Text("Read"),
                            ));
                          }
                          if (characteristic.properties
                                  .contains(CharacteristicProperties.write) ||
                              characteristic.properties.contains(
                                  CharacteristicProperties.writeNoResponse)) {
                            buttons.add(ElevatedButton(
                              child: const Text("Write"),
                              onPressed: () async {
                                controller.callWriteSerivce(
                                    controller.servicesInfo.value[index],
                                    characteristic);
                              },
                            ));
                          }
                          if (characteristic.properties
                                  .contains(CharacteristicProperties.notify) ||
                              characteristic.properties.contains(
                                  CharacteristicProperties.indicate)) {
                            buttons.add(ElevatedButton(
                              child: const Text("Set Notify"),
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return SimpleDialog(
                                      title: const Text('Set Notify'),
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          child: const Text('Enable notify'),
                                          onPressed: () {
                                            controller.device!
                                                .setNotify(
                                                    controller
                                                        .servicesInfo
                                                        .value[index]
                                                        .serviceUuid,
                                                    characteristic.uuid,
                                                    true)
                                                .then((value) {
                                              if (value) {
                                                Navigator.pop(dialogContext);
                                              }
                                            });
                                          },
                                        ),
                                        SimpleDialogOption(
                                          child: const Text('Disable notify'),
                                          onPressed: () {
                                            controller.device!
                                                .setNotify(
                                                    controller
                                                        .servicesInfo
                                                        .value[index]
                                                        .serviceUuid,
                                                    characteristic.uuid,
                                                    false)
                                                .then((value) {
                                              if (value) {
                                                Navigator.pop(dialogContext);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ));
                          }
                          for (int i = 0;
                              i < characteristic.properties.length;
                              i++) {
                            properties += characteristic.properties[i]
                                .toString()
                                .replaceAll(
                                    RegExp("CharacteristicProperties."), "");
                            if (i < characteristic.properties.length - 1) {
                              properties += ",";
                            }
                          }
                          return FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Characteristic",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    const Text("UUID:",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                    Text(characteristic.uuid,
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Properties:",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                    Text(properties,
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: buttons,
                                ),
                                characteristic.descriptors.isEmpty
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0))
                                    : FittedBox(
                                        fit: BoxFit.contain,
                                        child: Row(
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0)),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Descriptors:",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: characteristic
                                                        .descriptors
                                                        .map((descriptor) {
                                                      String descriptorType =
                                                          "UnKnown";
                                                      switch (Platform.isAndroid
                                                          ? descriptor.uuid
                                                              .substring(4, 8)
                                                          : descriptor.uuid) {
                                                        case "2900":
                                                          descriptorType =
                                                              "Characteristic Extended Properties";
                                                          break;
                                                        case "2901":
                                                          descriptorType =
                                                              "Characteristic User Description";
                                                          break;
                                                        case "2902":
                                                          descriptorType =
                                                              "Client Characteristic Configuration";
                                                          break;
                                                        case "2903":
                                                          descriptorType =
                                                              "Server Characteristic Configuration";
                                                          break;
                                                        case "2904":
                                                          descriptorType =
                                                              "Characteristic Presentation Format";
                                                          break;
                                                        case "2905":
                                                          descriptorType =
                                                              "Characteristic Aggregate Format";
                                                          break;
                                                        case "2906":
                                                          descriptorType =
                                                              "Valid Range";
                                                          break;
                                                        case "2907":
                                                          descriptorType =
                                                              "External Report Reference Descriptor";
                                                          break;
                                                        case "2908":
                                                          descriptorType =
                                                              "Report Reference Descriptor";
                                                          break;
                                                      }
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(descriptorType,
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                  "UUID:",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey)),
                                                              Text(
                                                                  descriptor
                                                                      .uuid,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                            ],
                                                          ),
                                                          Row(children: [
                                                            ElevatedButton(
                                                              child: const Text(
                                                                  "Readd"),
                                                              onPressed: () {
                                                                controller.device!.readDescriptorData(
                                                                    controller
                                                                        .servicesInfo
                                                                        .value[
                                                                            index]
                                                                        .serviceUuid,
                                                                    characteristic
                                                                        .uuid,
                                                                    descriptor
                                                                        .uuid);
                                                              },
                                                            ),
                                                            descriptorType ==
                                                                    "Client Characteristic Configuration"
                                                                ? ElevatedButton(
                                                                    child: const Text(
                                                                        "Write _: "),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                dialogContext) {
                                                                          return SimpleDialog(
                                                                            title:
                                                                                const Text('Send'),
                                                                            children: <Widget>[
                                                                              TextField(
                                                                                autofocus: true,
                                                                                controller: controller.sendDataTextController,
                                                                                decoration: const InputDecoration(
                                                                                  hintText: "Enter hexadecimal,such as FED10101",
                                                                                ),
                                                                              ),
                                                                              TextButton(
                                                                                child: const Text("Send"),
                                                                                onPressed: () {
                                                                                  String dataStr = controller.sendDataTextController.text;
                                                                                  Uint8List data = Uint8List(dataStr.length ~/ 2);
                                                                                  for (int i = 0; i < dataStr.length ~/ 2; i++) {
                                                                                    data[i] = int.parse(dataStr.substring(i * 2, i * 2 + 2), radix: 16);
                                                                                  }
                                                                                  controller.device!.writeDescriptorData(controller.servicesInfo.value[index].serviceUuid, characteristic.uuid, descriptor.uuid, data);
                                                                                  controller.sendDataTextController.clear();
                                                                                  Navigator.pop(dialogContext);
                                                                                },
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  )
                                                                : const Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  )
                                                          ]),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  )
                                                ]),
                                          ],
                                        )),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
