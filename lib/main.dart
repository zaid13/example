import 'package:ble/ui/bluetooth_connections/view/bluetooth_connections_view.dart';
import 'package:ble/ui/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: BluetoothConnectionView(),
    );
  }
}
