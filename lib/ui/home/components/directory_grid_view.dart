import 'package:ble/constants/style/style.dart';
import 'package:ble/models/directory_node.dart';
import 'package:ble/ui/home/controller/home_controller.dart';
import 'package:ble/widgets/drawer/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DirectoryGridView extends StatelessWidget {
  final DirectoryNode directoryNode;

  DirectoryGridView({Key? key, required this.directoryNode}) : super(key: key);

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        iconTheme: IconThemeData(color: headingColor),
      ),
      drawer: getDrawer(),
      body: GetBuilder<HomeController>(
          id: 'home_view_id',
          builder: (controller) {
            print(controller.isFileLoading.value);
            return Column(
              children: [
                Obx(
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
                      : controller.isFileDataLoading.value || controller.isFileDownLoadingNow.value
                          ? Expanded(
                        child: Container(
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
                  ),
                      )
                      : Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: GridView.builder(
                            padding: EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 100,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: directoryNode.subdirectories!.length +
                                directoryNode.files!.length,
                            itemBuilder: (context, index) {
                              if (index < directoryNode.subdirectories!.length) {
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the tapped subdirectory
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DirectoryGridView(
                                          directoryNode:
                                          directoryNode.subdirectories![index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder,
                                        size: 50,
                                        color: secondaryColor,
                                      ),
                                      Expanded(
                                        child: Text(
                                          directoryNode.subdirectories![index].name ??
                                              "",
                                          maxLines: 5,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: secondaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                final fileIndex =
                                    index - directoryNode.subdirectories!.length;
                                return GestureDetector(
                                  onTap: () {
                                    controller.isFileDownLoadingNow.value  = true;
                                    controller.selectedFileIndex = controller.fileList
                                        .indexWhere((element) =>
                                    element.replaceFirst(
                                        "c:\\ble-reading\\", "") ==
                                        directoryNode.files![fileIndex]);
                                    controller.callWriteSerivce(
                                        controller.selectedService!,
                                        controller.selectedWriteCharacteristic!);
                                    ;
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.doc,
                                        size: 50,
                                        color: secondaryColor,
                                      ),
                                      Expanded(
                                        child: Text(
                                          directoryNode.files![fileIndex]
                                              .split('\\')
                                              .last,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: secondaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                )
                ,
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!controller.isFileDataLoading.value) {
            controller.getAllFilesInDirectory(directoryNode.getAllFiles());
          }
        },
        backgroundColor: mainColor,
        child: Icon(
          Icons.download,
          color: Colors.black,
        ),
      ),
    );
  }
}
