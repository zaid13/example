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

  Widget tileWidget(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );




    return Text(value.toInt().toString(), style: style, textAlign: TextAlign.right);
  }



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

    titlesData:FlTitlesData(

        bottomTitles: AxisTitles(

          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            interval: 1,
            getTitlesWidget: tileWidget,
          ),

        ) ,
        leftTitles:  AxisTitles(

          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            interval: 1,
            getTitlesWidget: tileWidget,
          ),

        ) ,
        rightTitles:  AxisTitles(

          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            interval: 1,
            getTitlesWidget: tileWidget,
          ),

        ) ,
      topTitles:  AxisTitles(

        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 18,
          interval: 1,
          getTitlesWidget: tileWidget,
        ),

      ) ,


    ),
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
