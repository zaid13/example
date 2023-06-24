import 'package:ble/constants/style/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartComponent extends StatefulWidget {
  LineChartComponent(
      {Key? key,
      required this.chartTile,
      required this.points,
      required this.lineColor})
      : super(key: key);

  String chartTile;

  List<FlSpot> points;

  Color lineColor;

  @override
  State<LineChartComponent> createState() => _LineChartComponentState();
}

class _LineChartComponentState extends State<LineChartComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '${widget.chartTile}',
            style: TextStyle(color: secondaryColor),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: LineChart(
            LineChartData(
                borderData: FlBorderData(
                    border: Border.all(color: secondaryColor, width: 1)),
                lineBarsData: [
                  LineChartBarData(
                    color: widget.lineColor,
                    isCurved: true,
                    spots: widget.points,
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
