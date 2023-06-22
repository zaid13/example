import 'package:ble/constants/style/style.dart';
import 'package:ble/constants/values/values.dart';
import 'package:ble/ui/bluetooth_connections/view/bluetooth_connections_view.dart';
import 'package:ble/ui/home/view/home_view.dart';
import 'package:ble/ui/live_data/controller/live_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';

class LiveDataView extends StatefulWidget {
  LiveDataView({Key? key}) : super(key: key);

  @override
  State<LiveDataView> createState() => _LiveDataViewState();
}

class _LiveDataViewState extends State<LiveDataView> {
  LiveDataController controller = Get.put(LiveDataController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.device = mainDevice;
    controller.listenToIncomingData();
    controller.listensToService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Real Time Status',
          style: TextStyle(color: headingColor),
        ),
        centerTitle: true,
        leading: Container(),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 8.0),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child: Icon(
        //         Icons.settings,
        //         color: headingColor,
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Obx(() => Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        InfoTile("PROGRAM:", controller.getProgramStatus()),
                        InfoTile(
                            "SET FLOW:", controller.getSetFlowValue() + ' lpm'),
                        InfoTile(
                            "DIFF. PRES.:",
                            controller.getDiffPressureValue() +
                                ' ' +
                                controller.getPressureUnit()),
                        InfoTile(
                            "STATIC PRES.:",
                            controller.getStaticPressureValue() +
                                ' ' +
                                controller.getPressureUnit()),
                        InfoTile("BAROM. PRES.:",
                            controller.getBaroMetricPressureValue() + " mbar"),
                        InfoTile("DUCT TEMP.:",
                            controller.getDuctTempValue() + ' °C'),
                        InfoTile("ISOKINETIC GRADE:",
                            controller.getISOKineticValue() + ' %'),
                        InfoTile("POINT:", controller.getPointDoneByTotal()),
                        InfoTile("ELAPSED TIME:",
                            controller.getElapsedTimeInMints() + ' m'),
                        InfoTile("SET TIME:",
                            controller.getSetPointTimeInMints() + ' m'),
                        InfoTile("REMAINING TIME:",
                            controller.getRemainingTimeInMints() + ' m'),
                      ],
                    ),
                  ),
                )),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => BluetoothConnectionView());
                  },
                  child: Text(
                    'Setup',
                    style: TextStyle(color: headingColor),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => HomeView());
                  },
                  child: Text(
                    'Download',
                    style: TextStyle(color: headingColor),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  InfoTile(String key, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              key,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(color: secondaryColor, fontSize: 20),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            height: 1,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
          ),
        )
      ],
    );
  }
}
