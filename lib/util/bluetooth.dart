import 'dart:io';
import 'dart:typed_data';
import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/config.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/providers/global_variables.dart';
import 'package:agent_second/providers/transaction_provider.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';

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
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trans(context, 'invoice_printing'),
        ),
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
                  color: colors.blue,
                  onPressed: () {
                    final List<Transaction> orders =
                        getIt<TransactionProvider>()
                            .getTodayOrderTransactions();
                    final List<Transaction> returns =
                        getIt<TransactionProvider>()
                            .getTodayReturnTransactions();

                    // print(orders[0].details);
                    // print(returns[0].details);
                    printTodayTransactions(orders, returns);
                  },
                  child: Text(trans(context, 'print_today_invoices'),
                      style: TextStyle(color: colors.white)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                child: RaisedButton(
                  color: colors.green,
                  onPressed: () {
                    _tesPrint(transaction);
                  },
                  child: Text(trans(context, 'print_invoice'),
                      style: TextStyle(color: colors.white)),
                ),
              ),
            ],
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

  Future<void> _tesPrint(Transaction transaction) async {
    bluetooth.isConnected.then((bool isConnected) {
      if (isConnected) {
        bluetooth.printImage("asstes/images/logo_trans.svg");
        bluetooth.printCustom("AL SAHARI BAKERY", 1, 1);

        bluetooth.printCustom(
            "MD BIN SALEM STREET RAK.UAE Tel:072226355", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("TRN : ${config.trn}", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("TAX INVOICE #${transaction.id}", 1, 1);
        bluetooth.printCustom("Invoice Type\nCredit", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("CUST : ${transaction.beneficiary}", 1, 0);
        bluetooth.printCustom(
            "CUST TRN : ${getIt<GlobalVars>().getbenInFocus().trn ?? "N/A"}",
            1,
            0);
        bluetooth.printCustom("Date : ${transaction.transDate}", 1, 0);
        bluetooth.printCustom("Place : ${transaction.address}", 1, 0);
        bluetooth.printNewLine();

        bluetooth.printCustom(
            "SLNO  PRODUCT NAME            OYT  RATE  TOTAL", 1, 1);
        for (int i = 0; i < transaction.details.length; i++) {
          bluetooth.printCustom(
              "$i  ${transaction.details[i].item}   ${transaction.details[i].quantity}   ${transaction.details[i].itemPrice}   ${transaction.details[i].total}",
              1,
              1);
        }
        final double taxMony = config.tax / 100 * transaction.amount;
        final double totalBeforTax =
            transaction.amount - config.tax / 100 * transaction.amount;

        bluetooth.printNewLine();
        bluetooth.printCustom("DISCOUNT 0.0", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("SUB TOTAL $totalBeforTax", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("VAT AMOUNT ${taxMony.toStringAsFixed(2)}", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("NET TOTAL  ${transaction.amount}", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Salesman:${transaction.agent}",
            "     Car No:${config.verchilId}", 0);
        bluetooth.printLeftRight("SIGNATURE", "", 0);

        bluetooth.paperCut();
      } else {
        print("iam not connected ");
      }
    });
  }

  Future<void> printTodayTransactions(List<Transaction> orderTransactions,
      List<Transaction> returnTransactions) async {
    double orderAmount = 0.0;
    double returnAmount = 0.0;
    orderTransactions.forEach((Transaction element) {
      for (int i = 0; i < element.details.length; i++) {
        print(
            "$i  ${element.details[i].item}  ${element.details[i].quantity}   ${element.details[i].itemPrice}   ${element.details[i].total}");
      }
      //orderAmount += element.amount;
      print("new line");
    });
    print("RETURN");
    returnTransactions.forEach((Transaction element) {
      for (int i = 0; i < element.details.length; i++) {
        print(
            "$i  ${element.details[i].item}  ${element.details[i].quantity}   ${element.details[i].itemPrice}   ${element.details[i].total}");
      }
     // returnAmount += element.amount;
      print("new line");
    });
    // final double taxMony = config.tax / 100 * orderAmount;
    // final double totalfterReturn = orderAmount - returnAmount;
    // print(
    //     "tax money ${taxMony.toStringAsFixed(2)}  total: ${totalfterReturn.toStringAsFixed(2)}");
    bluetooth.isConnected.then((bool isConnected) {
      if (isConnected) {
        bluetooth.printCustom("AL SAHARI BAKERY", 1, 1);

        bluetooth.printCustom(
            "MD BIN SALEM STREET RAK.UAE Tel:072226355", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("TRN : ${config.trn}", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("TAX INVOICE #${transaction.id}", "", 0);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("CUST : ${transaction.beneficiary}", 1, 0);
        final String custTRN =
            (getIt<GlobalVars>().getbenInFocus().trn) != "null"
                ? getIt<GlobalVars>().getbenInFocus().trn
                : "N/A";
        bluetooth.printCustom("CUST TRN : $custTRN", 1, 0);
        bluetooth.printCustom("Date : ${transaction.transDate}", 1, 0);
        bluetooth.printCustom("Place : ${transaction.address}", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "SLNO  PRODUCT NAME        OYT  RATE  TOTAL", 1, 0);
            bluetooth.printNewLine();
        // bluetooth.printCustom("OYT  RATE  TOTAL", 1, 2);

        orderTransactions.forEach((Transaction element) {
          for (int i = 0; i < element.details.length; i++) {
            bluetooth.printCustom(
                "$i  ${element.details[i].item}  ${element.details[i].quantity}   ${element.details[i].itemPrice}   ${element.details[i].total.toStringAsFixed(2)}",
                0,
                0);
            // bluetooth.printCustom(
            //     "${element.details[i].quantity}   ${element.details[i].itemPrice}   ${element.details[i].total}",
            //     1,
            //     2);
          }
          orderAmount += element.amount;
          bluetooth.printNewLine();
        });
        bluetooth.printNewLine();
        bluetooth.printCustom("RETURN", 1, 1);
        bluetooth.printNewLine();
        returnTransactions.forEach((Transaction element) {
          for (int i = 0; i < element.details.length; i++) {
            bluetooth.printCustom(
                "$i  ${element.details[i].item}   ${element.details[i].quantity}   ${element.details[i].itemPrice}   ${element.details[i].total.toStringAsFixed(2)}",
                0,
                0);
            // bluetooth.printCustom(
            //     "${element.details[i].quantity}   ${element.details[i].itemPrice}   ${element.details[i].total}",
            //     1,
            //     2);
          }
          returnAmount += element.amount;
          bluetooth.printNewLine();
        });
        final double taxMony = config.tax / 100 * orderAmount;
        final double totalfterReturn = orderAmount - returnAmount;

        bluetooth.printNewLine();
        bluetooth.printCustom("DISCOUNT: 0.0", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "ORDER with Tax: ${orderAmount.toStringAsFixed(2)}", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "RETURN with Tax: ${returnAmount.toStringAsFixed(2)}", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "VAT AMOUNT: ${taxMony.toStringAsFixed(2)}", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "NET TOTAL:  ${totalfterReturn.toStringAsFixed(2)}", 1, 2);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Salesman:${transaction.agent}",
            "    Car No:${config.verchilId}", 0);
        bluetooth.printLeftRight("SIGNATURE", "", 0);
        bluetooth.paperCut();
      } else {
        print("iam not connected ");
      }
    });
  }
}
