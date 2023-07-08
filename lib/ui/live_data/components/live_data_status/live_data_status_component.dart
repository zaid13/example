import 'package:ble/constants/style/style.dart';
import 'package:ble/ui/live_data/controller/live_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveDataStatusComponent extends StatefulWidget {
  LiveDataStatusComponent({Key? key, required this.controller})
      : super(key: key);

  LiveDataController controller;

  @override
  State<LiveDataStatusComponent> createState() =>
      _LiveDataStatusComponentState();
}

class _LiveDataStatusComponentState extends State<LiveDataStatusComponent> {
  late LiveDataController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              InfoTile("PROGRAM:", controller.getProgramStatus()),
              InfoTile("PUMP:", controller.getPumpStatus(), isPumpValue: true),
              InfoTile("SET FLOW:", controller.getSetFlowValue() + ' lpm'),
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
              InfoTile("DUCT TEMP.:", controller.getDuctTempValue() + ' °C'),
              InfoTile(
                  "ISOKINETIC GRADE:", controller.getISOKineticValue() + ' %'),
              InfoTile("POINT:", controller.getPointDoneByTotal()),
              InfoTile(
                  "ELAPSED TIME:", controller.getElapsedTimeInMints() + ' m'),
              InfoTile("SET TIME:", controller.getSetPointTimeInMints() + ' m'),
              InfoTile("REMAINING TIME:",
                  controller.getRemainingTimeInMints() + ' m'),
              InfoTile("AXIS:", controller.getAxis()),
              InfoTile("VELOCITY:", controller.getVelocity() + ' m/s'),
              InfoTile("UPDATE TIME:", controller.getDateTime() ),
            ],
          )),
    );
  }

  InfoTile(String key, String value, {bool isPumpValue = false}) {
    return Column(
      children: [
        Container(
          color: isPumpValue ? controller.getPumpStatusColor() : null,
          child: Row(
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
