import 'package:flutter_blue/flutter_blue.dart';

abstract class BluetoothService {
  scanDevices();
}

class Bluetooth implements BluetoothService {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  scanDevices() async {
    flutterBlue.startScan(timeout: const Duration(seconds: 10));

    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

    flutterBlue.stopScan();
  }
}