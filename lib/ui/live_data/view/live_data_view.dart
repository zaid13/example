import 'package:ble/constants/style/style.dart';
import 'package:ble/ui/live_data/controller/live_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:get/get.dart';

class LiveDataView extends StatefulWidget {
  LiveDataView({required this.device, Key? key}) : super(key: key);

  Device device;

  @override
  State<LiveDataView> createState() => _LiveDataViewState();
}

class _LiveDataViewState extends State<LiveDataView> {
  LiveDataController controller = Get.put(LiveDataController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.device = widget.device;
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
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: headingColor,
          ),
        ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'PROGRAM: ${controller.getProgramStatus()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'PUMP: ${controller.getPumpStatus()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'SET FLOW: ${controller.getSetFlowValue()} lpm',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'DIFF. PRES.: ${controller.getDiffPressureValue()} ${controller.getPressureUnit()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'STATIC PRES.: ${controller.getStaticPressureValue()} ${controller.getPressureUnit()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'BAROM. PRES.: ${controller.getBaroMetricPressureValue()} mbar',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'DUCT TEMP.: ${controller.getDuctTempValue()} °C',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'ISOKINETIC GRADE: ${controller.getISOKineticValue()}%',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'POINT: ${controller.getPointDoneByTotal()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'ELAPSED TIME: ${controller.getElapsedTimeInMints()} m',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'SET TIME: ${controller.getSetPointTimeInMints()} m',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'REMAINING TIME: ${controller.getRemainingTimeInMints()} m',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: secondaryColor, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )),
          ))
        ],
      ),
    );
  }
}
