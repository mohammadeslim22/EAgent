import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/widgets/delete_tarnsaction_dialog.dart';
import 'package:agent_second/widgets/text_form_input.dart';
import 'package:agent_second/widgets/units_cooficients_dialoge.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderScreen extends StatefulWidget {
 const OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Set<int> selectedOptions = <int>{};
  int indexedStackId = 0;
  List<int> specializations = <int>[1, 2, 3, 4, 5];
  final TextEditingController searchController = TextEditingController();

  int groupValue = 0;
  double animatedHight = 0;
  Widget childForDragging(int item) {
    return Card(
      shape: RoundedRectangleBorder(
          side:const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(8.0)),
      color: selectedOptions.contains(item) ? Colors.grey : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedOptions.add(item);
          });
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 1.0, color: Colors.green)),
                  child: Text("20/100", style: styles.smallButton),
                )
              ],
            ),
            const SizedBox(height: 4),
            SvgPicture.asset("assets/images/snacks.svg", width: 64, height: 60),
            Text("Chips", style: styles.smallbluestyle),
            Text("20.00", style: styles.mystyle),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "altriq")),
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete, size: 36),
                  onPressed: () {
                    showGeneralDialog<dynamic>(
                        barrierLabel: "Label",
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.73),
                        transitionDuration: const Duration(milliseconds: 350),
                        context: context,
                        pageBuilder: (BuildContext context,
                            Animation<double> anim1, Animation<double> anim2) {
                          return const TransactionDeleteDialog();
                        });
                  }),
              Container(
                margin: const EdgeInsets.only(top: 2, right: 6, left: 6),
                width: 300,
                child: TextFormInput(
                  text: trans(context, 'type'),
                  cController: searchController,
                  prefixIcon: Icons.search,
                  kt: TextInputType.emailAddress,
                  obscureText: false,
                  readOnly: false,
                  onTab: () {},
                  onFieldSubmitted: () {},
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width / 2,
              child: GridView.count(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  crossAxisCount: 5,
                  childAspectRatio: .7,
                  addRepaintBoundaries: true,
                  children: specializations.map((int item) {
                    return !selectedOptions.contains(item)
                        ? Draggable<int>(
                            childWhenDragging: childForDragging(item),
                            onDragStarted: () {
                              setState(() {
                                indexedStackId = 1;
                                animatedHight = 160;
                              });
                            },
                            onDragEnd: (DraggableDetails t) {
                              setState(() {
                                indexedStackId = 0;
                                animatedHight = 0;
                              });
                            },
                            data: item,
                            feedback: Column(
                              children: <Widget>[
                                SvgPicture.asset("assets/images/snacks.svg",
                                    width: 64, height: 60),
                                Material(
                                    color: Colors.transparent,
                                    textStyle: styles.angrywhitestyle,
                                    child:const Text("chips")),
                              ],
                            ),
                            child: childForDragging(item))
                        : childForDragging(item);
                  }).toList()),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[300]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(trans(context, "type"),
                              style: styles.mystyle)),
                      Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 32),
                              Text(trans(context, "quantity"),
                                  style: styles.mystyle,
                                  textAlign: TextAlign.start),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(trans(context, "unit"),
                              style: styles.mystyle)),
                      Expanded(
                          flex: 1,
                          child: Text(trans(context, "u_price"),
                              style: styles.mystyle)),
                      Expanded(
                        flex: 1,
                        child: Text(
                          trans(context, "t_price"),
                          style: styles.mystyle,
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(
                  children: <Widget>[
                    if (indexedStackId == 1) Container(
                            margin: const EdgeInsets.only(left: 16),
                            color: Colors.grey[300],
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    const SizedBox(height: 50),
                                    Center(
                                      child: Text(
                                        trans(context, 'drage_here'),
                                        style: styles.angrywhitestyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                AnimatedContainer(
                                  height: animatedHight,
                                  duration:const Duration(milliseconds: 900),
                                  child: DottedBorder(
                                    color: Colors.black,
                                    borderType: BorderType.RRect,
                                    strokeWidth: 2,
                                    child: DragTarget<int>(
                                      onWillAccept: (int data) {
                                        return true;
                                      },
                                      onAccept: (int value) {
                                        setState(() {
                                          selectedOptions.add(value);
                                          indexedStackId = 0;
                                          animatedHight = 0;
                                        });
                                      },
                                      onLeave: (dynamic value) {},
                                      builder: (BuildContext context,
                                          List<int> candidateData,
                                          List<dynamic> rejectedData) {
                                        print(candidateData);
                                        return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            color: Colors.transparent);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) else Container(),
                    if (selectedOptions.isNotEmpty) GridView.count(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 12),
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            primary: true,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3,
                            crossAxisCount: 1,
                            childAspectRatio: 6,
                            addRepaintBoundaries: true,
                            children: selectedOptions.map((int item) {
                              return Slidable(
                                  actionPane: const SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'More',
                                      color: Colors.black45,
                                      icon: Icons.more_horiz,
                                      onTap: () {},
                                    ),
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        setState(() {
                                          selectedOptions.remove(item);
                                        });
                                      },
                                    ),
                                  ],
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1, color: Colors.green),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Chips",
                                                style: styles
                                                    .typeNameinOrderScreen),
                                            const SizedBox(height: 12),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                          "assets/images/snacks.svg",
                                                          height: 50),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                          maxRadius: 16,
                                                          child:
                                                              Icon(Icons.add)),
                                                      const SizedBox(width: 12),
                                                      Text("13.00",
                                                          style:
                                                              styles.mystyle),
                                                      const SizedBox(width: 12),
                                                      CircleAvatar(
                                                          maxRadius: 16,
                                                          child: Icon(
                                                            Icons.remove,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: FlatButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      showGeneralDialog<
                                                          dynamic>(
                                                        barrierLabel: "Label",
                                                        barrierDismissible:
                                                            true,
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.73),
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    350),
                                                        context: context,
                                                        pageBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Animation<
                                                                        double>
                                                                    anim1,
                                                                Animation<
                                                                        double>
                                                                    anim2) {
                                                          return const UnitsCooficientsDialog();
                                                        },
                                                        transitionBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Animation<
                                                                        double>
                                                                    anim1,
                                                                Animation<
                                                                        double>
                                                                    anim2,
                                                                Widget child) {
                                                          return SlideTransition(
                                                            position: Tween<
                                                                        Offset>(
                                                                    begin:
                                                                        const Offset(
                                                                            0,
                                                                            1),
                                                                    end:
                                                                        const Offset(
                                                                            0,
                                                                            0))
                                                                .animate(anim1),
                                                            child: child,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("كرتونة",
                                                            style:
                                                                styles.mystyle,
                                                            textAlign: TextAlign
                                                                .start),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "20.00",
                                                    style: styles.mystyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "260.00",
                                                    style: styles.mystyle,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Row(
                                            //   children: <Widget>[
                                            //     Column(
                                            //       children: <Widget>[
                                            //         const SizedBox(height: 12),
                                            //         SvgPicture.asset(
                                            //             "assets/images/snacks.svg",
                                            //             width: 64,
                                            //             height: 50),
                                            //       ],
                                            //     ),
                                            //     const SizedBox(width: 32),
                                            //     Expanded(
                                            //       child: Row(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment
                                            //                 .spaceBetween,
                                            //         children: <Widget>[
                                            //           Row(
                                            //             children: <Widget>[
                                            //               CircleAvatar(
                                            //                   maxRadius: 16,
                                            //                   child: Icon(
                                            //                       Icons.add)),
                                            //               const SizedBox(
                                            //                   width: 12),
                                            //               Text("13.00",
                                            //                   style: styles
                                            //                       .mystyle),
                                            //               const SizedBox(
                                            //                   width: 12),
                                            //               CircleAvatar(
                                            //                   maxRadius: 16,
                                            //                   child: Icon(
                                            //                     Icons.remove,
                                            //                   )),
                                            //             ],
                                            //           ),
                                            //           FlatButton(
                                            //             padding:
                                            //                 EdgeInsets.zero,
                                            //             onPressed: () {
                                            //               showGeneralDialog<
                                            //                   dynamic>(
                                            //                 barrierLabel:
                                            //                     "Label",
                                            //                 barrierDismissible:
                                            //                     true,
                                            //                 barrierColor: Colors
                                            //                     .black
                                            //                     .withOpacity(
                                            //                         0.73),
                                            //                 transitionDuration:
                                            //                     const Duration(
                                            //                         milliseconds:
                                            //                             350),
                                            //                 context: context,
                                            //                 pageBuilder: (BuildContext
                                            //                         context,
                                            //                     Animation<
                                            //                             double>
                                            //                         anim1,
                                            //                     Animation<
                                            //                             double>
                                            //                         anim2) {
                                            //                   return UnitsCooficientsDialog();
                                            //                 },
                                            //                 transitionBuilder:
                                            //                     (BuildContext
                                            //                             context,
                                            //                         Animation<
                                            //                                 double>
                                            //                             anim1,
                                            //                         Animation<
                                            //                                 double>
                                            //                             anim2,
                                            //                         Widget
                                            //                             child) {
                                            //                   return SlideTransition(
                                            //                     position: Tween<
                                            //                                 Offset>(
                                            //                             begin: const Offset(
                                            //                                 0,
                                            //                                 1),
                                            //                             end: const Offset(
                                            //                                 0,
                                            //                                 0))
                                            //                         .animate(
                                            //                             anim1),
                                            //                     child: child,
                                            //                   );
                                            //                 },
                                            //               );
                                            //             },
                                            //             child: Text("كرتونة",
                                            //                 style:
                                            //                     styles.mystyle),
                                            //           ),
                                            //           Text("20.00",
                                            //               style:
                                            //                   styles.mystyle),
                                            //           Text("260.00",
                                            //               style:
                                            //                   styles.mystyle),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            }).toList()) else Container(),
                  ],
                )),
                bottomTotal()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTotal() {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(trans(context, 'total') + " ", style: styles.mywhitestyle),
                Text("1500.00", style: styles.mywhitestyle)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 160,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.green,
                  onPressed: () {},
                  child:
                      Text(trans(context, "draft"), style: styles.mywhitestyle),
                ),
              ),
              const SizedBox(width: 32),
              Container(
                width: 160,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pushNamed(context, "/Payment_Screen");
                  },
                  child:
                      Text(trans(context, "order"), style: styles.mywhitestyle),
                ),
              ),
              const SizedBox(width: 32),
              Container(
                width: 160,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.red,
                  onPressed: () {},
                  child: Text(trans(context, "cancel"),
                      style: styles.mywhitestyle),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
