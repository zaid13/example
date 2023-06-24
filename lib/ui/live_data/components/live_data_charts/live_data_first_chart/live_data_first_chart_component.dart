import 'package:ble/ui/live_data/components/line_chart/line_chart_component.dart';
import 'package:ble/ui/live_data/controller/live_data_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveDataFirstChartComponent extends StatefulWidget {
  LiveDataFirstChartComponent({Key? key, required this.controller})
      : super(key: key);

  LiveDataController controller;

  @override
  State<LiveDataFirstChartComponent> createState() =>
      _LiveDataFirstChartComponentState();
}

class _LiveDataFirstChartComponentState
    extends State<LiveDataFirstChartComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveDataController>(
        id: 'live_data_first_chart_view_id',
        builder: ((controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => LineChartComponent(
                    chartTile: 'Differential Pressure',
                    points: getPoints(widget.controller.diffPressure.value),
                    lineColor: Colors.red,
                  ),
                ),
                Obx(
                  () => LineChartComponent(
                    chartTile: 'Duct Temperature',
                    points: getPoints(widget.controller.ductTemp.value),
                    lineColor: Colors.green,
                  ),
                ),
              ],
            ),
          );
        }));
  }

  getPoints(List<double> value) {
    List<FlSpot> spots = [];
    for (int i = 0; i < value.length; i++) {
      spots.add(FlSpot((i + 1).toDouble(), value[i]));
    }
    return spots;
  }
}
