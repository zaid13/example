import 'package:ble/constants/style/style.dart';
import 'package:ble/ui/bluetooth_connections/view/bluetooth_connections_view.dart';
import 'package:ble/ui/home/view/home_view.dart';
import 'package:ble/ui/live_data/view/live_data_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

getDrawer() {
  return Drawer(
    backgroundColor: bgColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: secondaryColor,
            ),
            child: Center(
              child: Image.asset(
                'assets/splash_logo.jpg',
                fit: BoxFit.contain,
              ),
            )),
        GestureDetector(
          onTap: () {
            Get.to(() => BluetoothConnectionView());
          },
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Setup',
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                ),
              )),
        ),
        Divider(
          color: secondaryColor,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => LiveDataView());
          },
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Live Data',
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                ),
              )),
        ),
        Divider(
          color: secondaryColor,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => HomeView());
          },
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Download',
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                ),
              )),
        ),
        Divider(
          color: secondaryColor,
        ),
      ],
    ),
  );
}
