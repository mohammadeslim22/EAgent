import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:flutter/material.dart';

class UnitsCooficientsDialog extends StatefulWidget {
 const UnitsCooficientsDialog({Key key}) : super(key: key);

  @override
  _UnitsCooficientsDialogState createState() => _UnitsCooficientsDialogState();
}

class _UnitsCooficientsDialogState extends State<UnitsCooficientsDialog> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 400,
        width: 600,
        margin: const EdgeInsets.only(bottom: 200, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SizedBox.expand(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      trans(context, "unit"),
                      style: styles.thirtyblack,
                    ),
                    Text(
                      trans(context, "coefficient_stability"),
                      style: styles.thirtyblack,
                    )
                  ],
                ),
                const SizedBox(height: 12),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        groupValue = 0;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                           width: 200,
                          child: Row(
                            children: <Widget>[
                              Radio<int>(
                                value: 0,
                                groupValue: groupValue,
                                onChanged: (int t) {
                                  setState(() {
                                    groupValue = t;
                                  });
                                },
                              ),
                              Text('كرتونة', style: styles.smallbluestyle)
                            ],
                          ),
                        ),
                        
                        Text("", style: styles.underHeadgray),
                      ],
                    )),
                FlatButton(
                  
                  onPressed: () {
                    setState(() {
                      groupValue = 1;
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: Row(
                          children: <Widget>[
                            Radio<int>(
                              value: 1,
                              groupValue: groupValue,
                              onChanged: (int t) {
                                setState(() {
                                  groupValue = t;
                                });
                              },
                            ),
                            Text('عبوة', style: styles.smallbluestyle)
                          ],
                        ),
                      ),
                     
                      Text("( 1/2 )", style: styles.underHeadgray),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        groupValue = 2;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                           width: 200,
                          child: Row(
                            children: <Widget>[
                              Radio<int>(
                                value: 2,
                                groupValue: groupValue,
                                onChanged: (int t) {
                                  setState(() {
                                    groupValue = t;
                                  });
                                },
                              ),
                              Text('دزينة', style: styles.smallbluestyle)
                            ],
                          ),
                        ),
                        
                        Text("( 1/2 )", style: styles.underHeadgray),
                      ],
                    )),
               const Spacer(),
                const Divider(thickness: 2, color: Colors.grey),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: colors.trans,
                        child: FlatButton(
                          autofocus: true,
                          onPressed: () {},
                          child: Text(trans(context, "ok_unit"),
                              style: styles.underHeadgreen),
                        ),
                      ),
                    ),
                    verticalDiv(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: colors.trans,
                        ),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(trans(context, "cancel"),
                              style: styles.underHeadred),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget verticalDiv() {
  return Container(
      padding: EdgeInsets.zero,
      child: const VerticalDivider(
        color: Colors.grey,
        thickness: 2,
      ),
      height: 80);
}
