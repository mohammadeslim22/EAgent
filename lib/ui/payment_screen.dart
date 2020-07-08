import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentScreen extends StatefulWidget {
 const PaymentScreen({Key key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int groupValue = 0;
  bool patmentTypeCash = true;
  final TextEditingController paymentCashController = TextEditingController();
  final TextEditingController paymentDeptController = TextEditingController();
  final TextEditingController exDateController = TextEditingController();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController cvcCashController = TextEditingController();
  final TextEditingController ammountPayController = TextEditingController();
  @override
  void initState() {
    super.initState();
    paymentCashController.text = "1,000.00/00,00";
    paymentDeptController.text = "00.00";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(trans(context, 'altariq')),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  width: MediaQuery.of(context).size.width / 2.25,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset("assets/images/payment.svg"),
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
                              setState(() {
                                patmentTypeCash = false;
                                groupValue = t;
                              });
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      width: MediaQuery.of(context).size.width / 2.25,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset("assets/images/payment_cash.svg"),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: false,
                            keyboardType: TextInputType.number,
                            onTap: () {},
                            textAlign: TextAlign.center,
                            controller: paymentCashController,
                            style: styles.paymentCashStyle,
                            obscureText: false,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: colors.green)),
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: trans(context, 'cash_recieved'),
                                hintStyle: TextStyle(
                                    color: colors.ggrey, fontSize: 15),
                                disabledBorder:const OutlineInputBorder(
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
                                    const EdgeInsets.symmetric(vertical: 16),
                                prefixIcon: Icon(
                                  Icons.attach_money,
                                ),
                                prefix: Text(
                                  trans(context, 'cash_recieved'),
                                )),
                            onFieldSubmitted: (String v) {
                              //  onFieldSubmitted();
                            },
                            validator: (String error) {
                              return "";
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: false,
                            keyboardType: TextInputType.number,
                            onTap: () {},
                            controller: paymentCashController,
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
                                hintText: trans(context, 'debt'),
                                hintStyle: TextStyle(
                                    color: colors.ggrey, fontSize: 15),
                                disabledBorder:const OutlineInputBorder(
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
                                    const EdgeInsets.symmetric(vertical: 16),
                                prefixIcon: Icon(Icons.money_off),
                                prefix: Text(
                                  trans(context, 'debt'),
                                )),
                            onFieldSubmitted: (String v) {
                              //  onFieldSubmitted();
                            },
                            validator: (String error) {
                              return "";
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      width: MediaQuery.of(context).size.width / 2.25,
                      height: MediaQuery.of(context).size.height / 1.5,
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
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 160,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          showGeneralDialog<dynamic>(
                              barrierLabel: "Label",
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.73),
                              transitionDuration:
                                  const Duration(milliseconds: 350),
                              context: context,
                              pageBuilder: (BuildContext context,
                                  Animation<double> anim1,
                                  Animation<double> anim2) {
                                return Container(
                                  color: Colors.white,
                                  height: 600,
                                  width: 600,
                                   margin: const EdgeInsets.only(bottom: 60, left: 260, right: 260,top: 60),
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: SizedBox.expand(
                                      child: Column(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                              "assets/images/payment_done.svg"),
                                          Text(
                                              trans(context, 'payment_success'),
                                              style: styles.angrygreenstyle),
                                          Text(trans(
                                                  context, 'transaction_no:') +
                                              " 1335647946",style: styles.underHeadblack,),
                                        const  Divider(),
                                          Text(trans(context, 'ammount_payed:'"  800.00"),style: styles.mystyle,),
                                          Text(trans(context, 'order_no:') +
                                              "   5958",style: styles.mystyle,),
                                          Text("Mon , 22-9-2020   2:25 PM",style: styles.mystyle,)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text(trans(context, "confirm"),
                            style: styles.mywhitestyle),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Container(
                      width: 160,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.grey,
                        onPressed: () {},
                        child: Text(trans(context, "cancel"),
                            style: styles.mywhitestyle),
                      ),
                    ),
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
          height: isActive ? 26 : 22,
          width: isActive ? 26 : 22,
          decoration: BoxDecoration(
              color: !isActive ? Colors.green : Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(50))),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: isActive ? 26 : 22,
          width: isActive ? 26 : 22,
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
        disabledBorder:const OutlineInputBorder(
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
}
