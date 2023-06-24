import 'package:ble/ui/live_data/components/line_chart/line_chart_component.dart';
import 'package:ble/ui/live_data/controller/live_data_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveDataSecondChartComponent extends StatefulWidget {
  LiveDataSecondChartComponent({Key? key, required this.controller})
      : super(key: key);

  LiveDataController controller;

  @override
  State<LiveDataSecondChartComponent> createState() =>
      _LiveDataSecondChartComponentState();
}

class _LiveDataSecondChartComponentState
    extends State<LiveDataSecondChartComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveDataController>(
      id: 'live_data_second_chart_view_id',
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => LineChartComponent(
                  chartTile: 'Flow Rate',
                  points: getPoints(widget.controller.flowRate.value),
                  lineColor: Colors.orange,
                ),
              ),
              Obx(
                () => LineChartComponent(
                  chartTile: 'IsoKinetic Grade',
                  points: getPoints(widget.controller.isoKineticTemp.value),
                  lineColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getPoints(List<double> value) {
    List<FlSpot> spots = [];
    for (int i = 0; i < value.length; i++) {
      spots.add(FlSpot((i + 1).toDouble(), value[i]));
    }
    return spots;
  }
}
