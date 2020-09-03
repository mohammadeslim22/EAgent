import 'dart:io';
import 'dart:typed_data';
import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/config.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key key, this.transaction}) : super(key: key);

  final Transaction transaction;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Bluetooth> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = <BluetoothDevice>[];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  Transaction transaction;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    transaction = widget.transaction;
    //  initSavetoPath();
  }

  // Future<void> initSavetoPath() async {
  //   //read and write
  //   //image max 300px X 300px
  //   const String filename = 'yourlogo.png';
  //   final ByteData bytes =
  //       await rootBundle.load("assets/images/locationMarkerblue.png");
  //   final String dir = (await getApplicationDocumentsDirectory()).path;
  //   writeToFile(bytes, '$dir/$filename');
  //   setState(() {
  //     pathImage = '$dir/$filename';
  //   });
  // }

  Future<void> initPlatformState() async {
    final bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = <BluetoothDevice>[];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("exception happened");
    }

    bluetooth.onStateChanged().listen((int state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) {
      return;
    }

    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Blue Thermal Printer'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: DropdownButton<dynamic>(
                        items: _getDeviceItems(),
                        onChanged: (dynamic value) =>
                            setState(() => _device = value as BluetoothDevice),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.brown,
                      onPressed: () {
                        initPlatformState();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(color: colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    RaisedButton(
                      color: _connected ? colors.red : colors.green,
                      onPressed: _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: RaisedButton(
                    color: colors.green,
                    onPressed: () {
                      _tesPrint();
                      // testPrint.sample(pathImage);
                    },
                    child: Text(trans(context, 'print_invoice'),
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    final List<DropdownMenuItem<BluetoothDevice>> items =
        <DropdownMenuItem<BluetoothDevice>>[];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem<BluetoothDevice>(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((BluetoothDevice device) {
        items.add(DropdownMenuItem<BluetoothDevice>(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((bool isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((dynamic error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final ByteBuffer buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  Future<void> _tesPrint() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((bool isConnected) {
      if (isConnected) {
        bluetooth.printCustom("AL SAHARI BAKERY", 1, 1);

        bluetooth.printCustom(
            "MD BIN SALEM STREET RAK.UAE Tel:072226355", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        // bluetooth.printCustom(
        //     "CUST ${transaction.beneficiary}", 1, 2);
        bluetooth.printCustom("CUST : CUSTOMER NAME", 1, 0);
        bluetooth.printCustom("TAX INVOICE", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("INVOICE NO. ${transaction.id}", 1, 0);
        bluetooth.printCustom("SLNO  PRODUCT NAME   OYT  RATE   TOTAL", 1, 1);
        for (int i = 0; i < transaction.details.length; i++) {
          bluetooth.printCustom(
              "$i  ${transaction.details[i].item}}   ${transaction.details[i].quantity}}   ${transaction.details[i].itemPrice}   ${transaction.details[i].total}",
              1,
              1);
        }
        // bluetooth.printCustom("Body left", 1, 0);
        final double taxMony = config.tax *transaction.amount; 
        final double totalBeforTax =transaction.amount- config.tax *transaction.amount; 

        bluetooth.printNewLine();
        bluetooth.printCustom("DISCOUNT 0.0", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("SUB TOTAL $totalBeforTax", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("VAT AMOUNT $taxMony", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("NET TOTAL  ${transaction.amount}", 1, 2);
        bluetooth.printNewLine();
        // bluetooth.printQRcode("Insert Your Own Text to Generate",);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      } else {
        print("iam not connected ");
      }
    });
  }
}
