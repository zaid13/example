import 'dart:developer';

import 'package:ble/constants/style/style.dart';
import 'package:ble/constants/values/values.dart';
import 'package:ble/ui/bluetooth_connections/view/bluetooth_connections_view.dart';
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
    // controller.listenToDeviceState();
    controller.resetData();
    controller.listenToIncomingData();
    controller.listensToService();
    // controller.writeFunction();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (controller.isFileDataLoading.value ||
            controller.isFileLoading.value) {
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Text(
              'Download Data',
              style: TextStyle(
                color: headingColor,
              ),
            ),
            centerTitle: true,
            // leading: Obx(() => controller.isSubFolderSelected.value ||
            //         controller.isMainFolderSeleceted.value
            //     ? GestureDetector(
            //         onTap: () {
            //           if (controller.isSubFolderSelected.value) {
            //             controller.isSubFolderSelected.value = false;
            //           } else {
            //             controller.isMainFolderSeleceted.value = false;
            //           }
            //         },
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Icon(
            //               Icons.arrow_back_ios_new,
            //               color: headingColor,
            //             ),
            //             Text(
            //               controller.isSubFolderSelected.value
            //                   ? 'SubFolder ${controller.subSelectedFolder.value}'
            //                   : 'MainFolder ${controller.mainSelectedFolder.value}',
            //               style: TextStyle(color: headingColor),
            //             )
            //           ],
            //         ),
            //       )
            //     : Container()),
            iconTheme: IconThemeData(color: headingColor),
          ),
          drawer: getDrawer(),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            style:
                                                TextStyle(color: headingColor),
                                          ),
                                          linearStrokeCap: LinearStrokeCap.butt,
                                          progressColor: mainColor,
                                          backgroundColor: secondaryColor,
                                        ),
                                      ),
                                      Text(
                                        'Fetching files data...',
                                        style: TextStyle(color: secondaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.count(
                                crossAxisCount: 3,
                                // padding: EdgeInsets.all(10),
                                children: List.generate(
                                  controller.fileData.value
                                      .length, // Replace with the actual number of items you want to display
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.writeFile(
                                            controller.fileData.value[index],
                                            index);
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.doc,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.175,
                                            color: secondaryColor,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.175,
                                              child: Text(
                                                controller.fileList[index]
                                                    .split('\\')
                                                    .last,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: secondaryColor),
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                    // !controller.isMainFolderSeleceted.value
                    //         ? Wrap(
                    //             children: [
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   controller.isMainFolderSeleceted.value =
                    //                       true;
                    //                   controller.mainSelectedFolder.value = 1;
                    //                 },
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.min,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Icon(
                    //                       Icons.folder,
                    //                       size: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.3,
                    //                       color: secondaryColor,
                    //                     ),
                    //                     SizedBox(
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width *
                    //                             0.3,
                    //                         child: const Text(
                    //                           'MainFolder 1',
                    //                           maxLines: 2,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.ellipsis,
                    //                           style: TextStyle(
                    //                               color: secondaryColor),
                    //                         ))
                    //                   ],
                    //                 ),
                    //               ),
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   controller.isMainFolderSeleceted.value =
                    //                       true;
                    //                   controller.mainSelectedFolder.value = 2;
                    //                 },
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.min,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Icon(
                    //                       Icons.folder,
                    //                       size: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.3,
                    //                       color: secondaryColor,
                    //                     ),
                    //                     SizedBox(
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width *
                    //                             0.3,
                    //                         child: const Text(
                    //                           'MainFolder 2',
                    //                           maxLines: 2,
                    //                           textAlign: TextAlign.center,
                    //                           overflow: TextOverflow.ellipsis,
                    //                           style: TextStyle(
                    //                               color: secondaryColor),
                    //                         ))
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //         : !controller.isSubFolderSelected.value
                    //             ? Wrap(
                    //                 children: [
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       controller.isSubFolderSelected.value =
                    //                           true;
                    //                       controller.subSelectedFolder.value =
                    //                           1;
                    //                     },
                    //                     child: Column(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         Icon(
                    //                           Icons.folder,
                    //                           size: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.3,
                    //                           color: secondaryColor,
                    //                         ),
                    //                         SizedBox(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width *
                    //                                 0.3,
                    //                             child: const Text(
                    //                               'SubFolder 1',
                    //                               maxLines: 2,
                    //                               textAlign: TextAlign.center,
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               style: TextStyle(
                    //                                   color: secondaryColor),
                    //                             ))
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       controller.isSubFolderSelected.value =
                    //                           true;
                    //                       controller.subSelectedFolder.value =
                    //                           2;
                    //                     },
                    //                     child: Column(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         Icon(
                    //                           Icons.folder,
                    //                           size: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.3,
                    //                           color: secondaryColor,
                    //                         ),
                    //                         SizedBox(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width *
                    //                                 0.3,
                    //                             child: const Text(
                    //                               'SubFolder 2',
                    //                               maxLines: 2,
                    //                               textAlign: TextAlign.center,
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               style: TextStyle(
                    //                                   color: secondaryColor),
                    //                             ))
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       controller.isSubFolderSelected.value =
                    //                           true;
                    //                       controller.subSelectedFolder.value =
                    //                           3;
                    //                     },
                    //                     child: Column(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         Icon(
                    //                           Icons.folder,
                    //                           size: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.3,
                    //                           color: secondaryColor,
                    //                         ),
                    //                         SizedBox(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width *
                    //                                 0.3,
                    //                             child: const Text(
                    //                               'SubFolder 3',
                    //                               maxLines: 2,
                    //                               textAlign: TextAlign.center,
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               style: TextStyle(
                    //                                   color: secondaryColor),
                    //                             ))
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               )
                    //             : Wrap(
                    //                 children: [
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       // controller.isMainFolderSeleceted.value = true;
                    //                       // controller.mainSelectedFolder.value = 1;
                    //                       if (controller
                    //                               .subSelectedFolder.value ==
                    //                           1) {
                    //                         controller.writeFile(
                    //                             controller
                    //                                 .fileData.value[controller
                    //                                         .mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 0
                    //                                 : 6],
                    //                             controller.mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 0
                    //                                 : 6);
                    //                       } else if (controller
                    //                               .subSelectedFolder.value ==
                    //                           2) {
                    //                         controller.writeFile(
                    //                             controller
                    //                                 .fileData.value[controller
                    //                                         .mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 2
                    //                                 : 8],
                    //                             controller.mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 2
                    //                                 : 8);
                    //                       } else if (controller
                    //                               .subSelectedFolder.value ==
                    //                           3) {
                    //                         controller.writeFile(
                    //                             controller
                    //                                 .fileData.value[controller
                    //                                         .mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 4
                    //                                 : 10],
                    //                             controller.mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 4
                    //                                 : 10);
                    //                       }
                    //                     },
                    //                     child: Column(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         Icon(
                    //                           CupertinoIcons.doc,
                    //                           size: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.3,
                    //                           color: secondaryColor,
                    //                         ),
                    //                         SizedBox(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width *
                    //                                 0.3,
                    //                             child: const Text(
                    //                               'File 1',
                    //                               maxLines: 2,
                    //                               textAlign: TextAlign.center,
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               style: TextStyle(
                    //                                   color: secondaryColor),
                    //                             ))
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       if (controller
                    //                               .subSelectedFolder.value ==
                    //                           1) {
                    //                         controller.writeFile(
                    //                             controller
                    //                                 .fileData.value[controller
                    //                                         .mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 1
                    //                                 : 7],
                    //                             controller.mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 1
                    //                                 : 7);
                    //                       } else if (controller
                    //                               .subSelectedFolder.value ==
                    //                           2) {
                    //                         controller.writeFile(
                    //                             controller
                    //                                 .fileData.value[controller
                    //                                         .mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 3
                    //                                 : 9],
                    //                             controller.mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 3
                    //                                 : 9);
                    //                       } else if (controller
                    //                               .subSelectedFolder.value ==
                    //                           3) {
                    //                         controller.writeFile(
                    //                             controller
                    //                                 .fileData.value[controller
                    //                                         .mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 5
                    //                                 : 11],
                    //                             controller.mainSelectedFolder
                    //                                         .value ==
                    //                                     1
                    //                                 ? 5
                    //                                 : 11);
                    //                       }
                    //                       // controller.isMainFolderSeleceted.value = true;
                    //                       // controller.mainSelectedFolder.value = 2;
                    //                     },
                    //                     child: Column(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         Icon(
                    //                           CupertinoIcons.doc,
                    //                           size: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.3,
                    //                           color: secondaryColor,
                    //                         ),
                    //                         SizedBox(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width *
                    //                                 0.3,
                    //                             child: const Text(
                    //                               'File 2',
                    //                               maxLines: 2,
                    //                               textAlign: TextAlign.center,
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               style: TextStyle(
                    //                                   color: secondaryColor),
                    //                             ))
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
