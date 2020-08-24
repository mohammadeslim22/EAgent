import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/ben.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {Key key,
      this.orderTotal,
      this.returnTotal,
      this.orderOrRetunOrCollection})
      : super(key: key);
  final double orderTotal;
  final double returnTotal;
  final int orderOrRetunOrCollection;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int groupValue = 0;
  bool patmentTypeCash = true;
  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController paymentCashController = TextEditingController();
  final TextEditingController paymentDeptController = TextEditingController();
  final TextEditingController exDateController = TextEditingController();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController cvcCashController = TextEditingController();
  final TextEditingController ammountPayController = TextEditingController();
  Ben _ben;
  String _type;
  String _deptValue = "00.00";
  // Transaction _transaction;
  @override
  void initState() {
    super.initState();
    _type = widget.orderOrRetunOrCollection == 0
        ? "order"
        : widget.orderOrRetunOrCollection == 1 ? "return" : "collection";
    _ben = getIt<GlobalVars>().getbenInFocus();
    paymentCashController.text = "${widget.orderTotal - widget.returnTotal}  ";
    paymentAmountController.text = "${widget.orderTotal}  ";
    paymentCashController.selection = TextSelection(
        baseOffset: 0, extentOffset: widget.orderTotal.toString().length);

    paymentDeptController.text = "${widget.returnTotal}  ";
  }

  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(trans(context, 'altariq'), style: styles.appBar),
        centerTitle: true,
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: MediaQuery.of(context).size.width / 2.25,
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset("assets/images/payment.svg",
                          height: 100, width: 100),
                      Text(trans(context, 'choose_payment_method'),
                          style: styles.underHeadblack),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile<int>(
                            secondary: SvgPicture.asset(
                                "assets/images/cash_Icon.svg",
                                height: 100),
                            value: 0,
                            activeColor: Colors.green,
                            groupValue: groupValue,
                            onChanged: (int t) {
                              setState(() {
                                patmentTypeCash = true;
                                groupValue = t;
                              });
                            },
                            title: Text(
                              trans(context, 'cash_payment'),
                              style: styles.smallButtonactivated,
                            ),
                          ),
                          RadioListTile<int>(
                            secondary: SvgPicture.asset(
                                "assets/images/card_Icon.svg",
                                height: 90),
                            value: 1,
                            activeColor: Colors.green,
                            groupValue: groupValue,
                            onChanged: (int t) {
                              // setState(() {
                              //   patmentTypeCash = false;
                              //   groupValue = t;
                              // });
                            },
                            title: Text(
                              trans(context, 'card_payment'),
                              style: styles.smallButtonactivated,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IndexedStack(
                index: patmentTypeCash ? 0 : 1,
                children: <Widget>[
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      width: MediaQuery.of(context).size.width / 2.25,
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset("assets/images/payment_cash.svg",
                              height: 100, width: 100),
                          const SizedBox(height: 8),
                          TextFormField(
                            readOnly: false,
                            keyboardType: TextInputType.number,
                            onTap: () {},
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: paymentCashController,
                            style: styles.paymentCashStyle,
                            obscureText: false,
                            onChanged: (String t) {
                              setState(() {
                                _deptValue = (double.parse(
                                            paymentAmountController.text
                                                .trim()) -
                                        double.parse(
                                            paymentCashController.text.trim()))
                                    .toString();
                              });
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: colors.green)),
                                filled: true,
                                fillColor: Colors.white70,
                                hintStyle: TextStyle(
                                    color: colors.ggrey, fontSize: 15),
                                disabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colors.green),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: const Icon(Icons.attach_money),
                                prefix: Text(
                                  trans(context, 'cash_recieved'),
                                )),
                            validator: (String error) {
                              return "";
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              controller: paymentAmountController,
                              style: styles.paymentCashStyle,
                              obscureText: false,
                              enabled: false,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: colors.green)),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  hintText: trans(context, 'cash_rquired'),
                                  hintStyle: TextStyle(
                                      color: colors.ggrey, fontSize: 15),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  prefixIcon: const Icon(Icons.attach_money),
                                  prefix: Text(trans(context, 'cash_total')))),
                          const SizedBox(height: 12),
                          TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            onTap: () {},
                            enabled: true,
                            controller: paymentDeptController,
                            style: styles.paymentCashStyle,
                            obscureText: false,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: colors.green)),
                                filled: true,
                                fillColor: Colors.white70,
                                hintStyle: TextStyle(
                                    color: colors.ggrey, fontSize: 15),
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.green,
                                )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: const Icon(Icons.money_off),
                                prefix: Text(trans(context, 'cash_given'))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      width: MediaQuery.of(context).size.width / 2.25,
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset("assets/images/payment_visa.svg"),
                          const SizedBox(height: 16),
                          paymentForm(
                              TextInputType.number,
                              cardNoController,
                              trans(context, 'card_no'),
                              () {},
                              Icons.credit_card),
                          const SizedBox(height: 16),
                          paymentForm(
                              TextInputType.number,
                              exDateController,
                              trans(context, 'ex_date'),
                              () {},
                              Icons.date_range),
                          const SizedBox(height: 16),
                          paymentForm(
                              TextInputType.number,
                              cvcCashController,
                              trans(context, 'cvv'),
                              () {},
                              Icons.calendar_view_day),
                          const SizedBox(height: 16),
                          paymentForm(
                              TextInputType.number,
                              ammountPayController,
                              trans(context, 'amount'),
                              () {},
                              Icons.monetization_on),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: <Widget>[
              circleBar(patmentTypeCash),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 110,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.green,
                        onPressed: () async {
                          showAWAITINGSENDOrderTruck();
                          switch (_type) {
                            case "collection":
                              {
                                try {
                                  if (await getIt<OrderListProvider>()
                                      .sendCollection(
                                          context,
                                          _ben.id,
                                          int.parse(paymentCashController.text),
                                          "confirmed")) {
                                    setState(() {
                                      paymentAmountController.text = "00.00";

                                      paymentCashController.text = "00.00";

                                      paymentDeptController.text = "00.00";
                                    });
                                  }
                                } catch (e) {
                                  print("error in collection");
                                  Navigator.pop(context);
                                }
                                Navigator.pop(context);
                              }
                              break;
                            default:
                              {
                                await getIt<OrderListProvider>()
                                    .payMYOrdersAndReturnList(context, _ben.id);
                                Navigator.pop(context);
                              }
                              break;
                          }
                        },
                        child: Text(trans(context, "confirm"),
                            style: styles.mywhitestyle),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Container(
                      width: 110,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.grey,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(trans(context, "cancel"),
                            style: styles.mywhitestyle),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: const EdgeInsets.all(16.0),
                            content: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    controller: noteController,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text(trans(context, "cancel")),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              FlatButton(
                                  child: Text(trans(context, "set")),
                                  onPressed: () {
                                    // add note to the payment
                                  })
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: isActive ? 16 : 12,
          width: isActive ? 16 : 12,
          decoration: BoxDecoration(
              color: !isActive ? Colors.green : Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(50))),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: isActive ? 16 : 12,
          width: isActive ? 16 : 12,
          decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(50))),
        ),
      ],
    );
  }

  Widget paymentForm(TextInputType kt, TextEditingController c, String hinttext,
      Function onSubmit, IconData id) {
    return TextFormField(
      readOnly: false,
      keyboardType: kt,
      onTap: () {},
      controller: c,
      style: styles.paymentCardStyle,
      obscureText: false,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.green)),
        filled: true,
        fillColor: Colors.white70,
        hintText: hinttext,
        hintStyle: TextStyle(color: colors.ggrey, fontSize: 15),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.green,
        )),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.green,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        prefixIcon: Icon(id, color: Colors.green),
      ),
      onFieldSubmitted: (String v) {
        onSubmit();
      },
      validator: (String error) {
        return "";
      },
    );
  }

  void showAWAITINGSENDOrderTruck() {
    showGeneralDialog<dynamic>(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.73),
        transitionDuration: const Duration(milliseconds: 350),
        context: context,
        pageBuilder: (BuildContext context, Animation<double> anim1,
            Animation<double> anim2) {
          return Container(
            height: 600,
            width: 600,
            margin: const EdgeInsets.only(
                bottom: 60, left: 260, right: 260, top: 60),
            child: const FlareActor("assets/images/DeliverytruckAnimation.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: "Animations"),
          );
        });
  }
}
