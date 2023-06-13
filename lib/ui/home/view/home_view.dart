import 'dart:developer';

import 'package:ble/ui/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  HomeView({required this.device, Key? key}) : super(key: key);
  Device device;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.device = widget.device;
    controller.listenToIncomingData();
    controller.listensToService();
    // controller.writeFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        centerTitle: true,
        leading: Obx(() => controller.isSubFolderSelected.value ||
                controller.isMainFolderSeleceted.value
            ? GestureDetector(
                onTap: () {
                  if (controller.isSubFolderSelected.value) {
                    controller.isSubFolderSelected.value = false;
                  } else {
                    controller.isMainFolderSeleceted.value = false;
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new),
                    Text(controller.isSubFolderSelected.value
                        ? 'SubFolder ${controller.subSelectedFolder.value}'
                        : 'MainFolder ${controller.mainSelectedFolder.value}')
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back))),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: SingleChildScrollView(
          child: Obx(
            () => controller.isFileLoading.value
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('Fetching files...'),
                        ],
                      ),
                    ),
                  )
                : !controller.isMainFolderSeleceted.value
                    ? Wrap(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.isMainFolderSeleceted.value = true;
                              controller.mainSelectedFolder.value = 1;
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: MediaQuery.of(context).size.width * 0.3,
                                  color: Color(0xff606268),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: const Text(
                                      'MainFolder 1',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black),
                                    ))
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.isMainFolderSeleceted.value = true;
                              controller.mainSelectedFolder.value = 2;
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: MediaQuery.of(context).size.width * 0.3,
                                  color: Color(0xff606268),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: const Text(
                                      'MainFolder 2',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )
                    : !controller.isSubFolderSelected.value
                        ? Wrap(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.isSubFolderSelected.value = true;
                                  controller.subSelectedFolder.value = 1;
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      size: MediaQuery.of(context).size.width *
                                          0.3,
                                      color: Color(0xff606268),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: const Text(
                                          'SubFolder 1',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.isSubFolderSelected.value = true;
                                  controller.subSelectedFolder.value = 2;
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      size: MediaQuery.of(context).size.width *
                                          0.3,
                                      color: Color(0xff606268),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: const Text(
                                          'SubFolder 2',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.isSubFolderSelected.value = true;
                                  controller.subSelectedFolder.value = 3;
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      size: MediaQuery.of(context).size.width *
                                          0.3,
                                      color: Color(0xff606268),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: const Text(
                                          'SubFolder 3',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Wrap(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // controller.isMainFolderSeleceted.value = true;
                                  // controller.mainSelectedFolder.value = 1;
                                  if (controller.subSelectedFolder.value == 1) {
                                    controller.writeFile(
                                        controller.fileData.value[controller
                                                    .mainSelectedFolder.value ==
                                                1
                                            ? 0
                                            : 6],
                                        controller.mainSelectedFolder.value == 1
                                            ? 0
                                            : 6);
                                  } else if (controller
                                          .subSelectedFolder.value ==
                                      2) {
                                    controller.writeFile(
                                        controller.fileData.value[controller
                                                    .mainSelectedFolder.value ==
                                                1
                                            ? 2
                                            : 8],
                                        controller.mainSelectedFolder.value == 1
                                            ? 2
                                            : 8);
                                  } else if (controller
                                          .subSelectedFolder.value ==
                                      3) {
                                    controller.writeFile(
                                        controller.fileData.value[controller
                                                    .mainSelectedFolder.value ==
                                                1
                                            ? 4
                                            : 10],
                                        controller.mainSelectedFolder.value == 1
                                            ? 4
                                            : 10);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.doc,
                                      size: MediaQuery.of(context).size.width *
                                          0.3,
                                      color: Color(0xff606268),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: const Text(
                                          'File 1',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (controller.subSelectedFolder.value == 1) {
                                    controller.writeFile(
                                        controller.fileData.value[controller
                                                    .mainSelectedFolder.value ==
                                                1
                                            ? 1
                                            : 7],
                                        controller.mainSelectedFolder.value == 1
                                            ? 1
                                            : 7);
                                  } else if (controller
                                          .subSelectedFolder.value ==
                                      2) {
                                    controller.writeFile(
                                        controller.fileData.value[controller
                                                    .mainSelectedFolder.value ==
                                                1
                                            ? 3
                                            : 9],
                                        controller.mainSelectedFolder.value == 1
                                            ? 3
                                            : 9);
                                  } else if (controller
                                          .subSelectedFolder.value ==
                                      3) {
                                    controller.writeFile(
                                        controller.fileData.value[controller
                                                    .mainSelectedFolder.value ==
                                                1
                                            ? 5
                                            : 11],
                                        controller.mainSelectedFolder.value == 1
                                            ? 5
                                            : 11);
                                  }
                                  // controller.isMainFolderSeleceted.value = true;
                                  // controller.mainSelectedFolder.value = 2;
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.doc,
                                      size: MediaQuery.of(context).size.width *
                                          0.3,
                                      color: Color(0xff606268),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: const Text(
                                          'File 2',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
          ),
        ),
      ),
    );
  }
}
