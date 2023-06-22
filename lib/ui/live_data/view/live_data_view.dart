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
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PROGRAM:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getProgramStatus()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PUMP:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getPumpStatus()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SET FLOW:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getSetFlowValue()} lpm',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DIFF. PRES.:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getDiffPressureValue()} ${controller.getPressureUnit()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'STATIC PRES.:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getStaticPressureValue()} ${controller.getPressureUnit()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'BAROM. PRES.:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getBaroMetricPressureValue()} mbar',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DUCT TEMP.:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getDuctTempValue()} °C',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ISOKINETIC GRADE:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getISOKineticValue()}%',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'POINT:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getPointDoneByTotal()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ELAPSED TIME:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getElapsedTimeInMints()} m',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SET TIME:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getSetPointTimeInMints()} m',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'REMAINING TIME:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${controller.getRemainingTimeInMints()} m',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1.5,
                          width: MediaQuery.of(context).size.width,
                          color: secondaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
}
