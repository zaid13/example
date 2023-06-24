import 'package:ble/constants/style/style.dart';
import 'package:ble/constants/values/values.dart';
import 'package:ble/ui/bluetooth_connections/view/bluetooth_connections_view.dart';
import 'package:ble/ui/home/view/home_view.dart';
import 'package:ble/ui/live_data/components/live_data_charts/live_data_first_chart/live_data_first_chart_component.dart';
import 'package:ble/ui/live_data/components/live_data_charts/live_data_second_chart/live_data_second_chart_component.dart';
import 'package:ble/ui/live_data/components/live_data_status/live_data_status_component.dart';
import 'package:ble/ui/live_data/controller/live_data_controller.dart';
import 'package:ble/widgets/drawer/drawer.dart';
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
    controller.resetChartsData();
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
        iconTheme: IconThemeData(color: headingColor),
      ),
      drawer: getDrawer(),
      body: Align(
          alignment: Alignment.center,
          child: PageView(
            children: [
              LiveDataStatusComponent(
                controller: controller,
              ),
              LiveDataFirstChartComponent(controller: controller),
              LiveDataSecondChartComponent(controller: controller),
            ],
          )),
    );
  }
}
