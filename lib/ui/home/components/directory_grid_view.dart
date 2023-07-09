import 'package:ble/constants/style/style.dart';
import 'package:ble/models/directory_node.dart';
import 'package:ble/ui/home/controller/home_controller.dart';
import 'package:ble/widgets/drawer/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
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
                              size: MediaQuery.of(context).size.width * 0.25,
                              color: secondaryColor,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  directoryNode.subdirectories![index].name ??
                                      "",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: secondaryColor),
                                ))
                          ],
                        ),
                      );
                    } else {
                      final fileIndex =
                          index - directoryNode.subdirectories!.length;
                      return GestureDetector(
                        onTap: () {
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
                              size: MediaQuery.of(context).size.width * 0.25,
                              color: secondaryColor,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  directoryNode.files![fileIndex]
                                      .split('\\')
                                      .last,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: secondaryColor),
                                ))
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
