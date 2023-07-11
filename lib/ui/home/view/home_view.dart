import 'dart:developer';

import 'package:ble/constants/style/style.dart';
import 'package:ble/constants/values/values.dart';
import 'package:ble/ui/bluetooth_connections/view/bluetooth_connections_view.dart';
import 'package:ble/ui/home/components/directory_grid_view.dart';
import 'package:ble/ui/home/controller/home_controller.dart';
import 'package:ble/ui/live_data/view/live_data_view.dart';
import 'package:ble/widgets/drawer/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.device = mainDevice;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetData();
      controller.listenToIncomingData();
      controller.listensToService();
    });
    // controller.listenToDeviceState();

    // controller.writeFunction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (controller.deviceSignalResultStream != null) {
      controller.deviceSignalResultStream!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        // appBar: AppBar(
        //   backgroundColor: mainColor,
        //   title: const Text(
        //     'Download Data',
        //     style: TextStyle(
        //       color: headingColor,
        //     ),
        //   ),
        //   centerTitle: true,
        //   // leading: Obx(() => controller.isSubFolderSelected.value ||
        //   //         controller.isMainFolderSeleceted.value
        //   //     ? GestureDetector(
        //   //         onTap: () {
        //   //           if (controller.isSubFolderSelected.value) {
        //   //             controller.isSubFolderSelected.value = false;
        //   //           } else {
        //   //             controller.isMainFolderSeleceted.value = false;
        //   //           }
        //   //         },
        //   //         child: Row(
        //   //           mainAxisSize: MainAxisSize.min,
        //   //           children: [
        //   //             Icon(
        //   //               Icons.arrow_back_ios_new,
        //   //               color: headingColor,
        //   //             ),
        //   //             Text(
        //   //               controller.isSubFolderSelected.value
        //   //                   ? 'SubFolder ${controller.subSelectedFolder.value}'
        //   //                   : 'MainFolder ${controller.mainSelectedFolder.value}',
        //   //               style: TextStyle(color: headingColor),
        //   //             )
        //   //           ],
        //   //         ),
        //   //       )
        //   //     : Container()),
        //   iconTheme: IconThemeData(color: headingColor),
        // ),
        // drawer: getDrawer(),
        body: GetBuilder<HomeController>(
            id: 'home_view_id',
            builder: (controller) {
              return Column(
                children: [
                  Expanded(
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
                                    CircularProgressIndicator(
                                      color: mainColor,
                                    ),
                                    Text(
                                      'Fetching files...',
                                      style: TextStyle(color: secondaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : controller.isFileDataLoading.value
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: new LinearPercentIndicator(
                                            alignment: MainAxisAlignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                            animateFromLastPercent: true,
                                            lineHeight: 30.0,
                                            percent: controller
                                                .getFileDataPercentage(),
                                            center: Text(
                                              "${(controller.getFileDataPercentage() * 100).round()}%",
                                              style: TextStyle(
                                                  color: headingColor),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.butt,
                                            progressColor: mainColor,
                                            backgroundColor: secondaryColor,
                                          ),
                                        ),
                                        Text(
                                          'Fetching files data...',
                                          style:
                                              TextStyle(color: secondaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : DirectoryGridView(
                                  directoryNode: controller.root.value),
                    ),
                  ),
                ],
              );
            }));
  }
}
