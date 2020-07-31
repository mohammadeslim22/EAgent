import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/Items.dart';
import 'package:agent_second/models/ben.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:agent_second/widgets/delete_tarnsaction_dialog.dart';
import 'package:agent_second/widgets/text_form_input.dart';
import 'package:agent_second/widgets/units_cooficients_dialoge.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/src/result/download_progress.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:agent_second/providers/order_provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key, this.ben}) : super(key: key);
  final Ben ben;
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int indexedStackId = 0;
  double totalPrice;
  Ben ben;

  double animatedHight = 0;
  final TextEditingController searchController = TextEditingController();
  Map<String, String> itemsBalances = <String, String>{};
  List<int> prices = <int>[];

  Widget childForDragging(SingleItem item) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(8.0)),
      color: getIt<OrderListProvider>().selectedOptions.contains(item.id)
          ? Colors.grey
          : Colors.white,
      child: InkWell(
        onTap: () {
          !getIt<OrderListProvider>().selectedOptions.contains(item.id)
              ? setState(() {
                  getIt<OrderListProvider>().addItemToList(item.id, item.name,
                      item.notes, item.queantity, item.unit, item.unitPrice);
                  getIt<OrderListProvider>().selectedOptions.add(item.id);
                })
              // ignore: unnecessary_statements
              : () {};
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
                  child: Text(ben.itemsBalances[item.id.toString()] ?? "",
                      style: styles.smallButton),
                )
              ],
            ),
            const SizedBox(height: 4),
            CachedNetworkImage(
              imageUrl: item.image ?? "",
              progressIndicatorBuilder: (BuildContext context, String url,
                      DownloadProgress downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (BuildContext context, String url, dynamic error) =>
                  Icon(Icons.error),
            ),
            Text(item.name, style: styles.smallbluestyle),
            Text(item.unitPrice.toString(), style: styles.mystyle),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ben = widget.ben;
    if (getIt<OrderListProvider>().dataLoaded) {
    } else {
      getIt<OrderListProvider>().indexedStack = 0;
      getIt<OrderListProvider>().getItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "altriq")),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //  getIt<OrderListProvider>().clearOrcerList();
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, size: 32),
            onPressed: () {
              getIt<OrderListProvider>().getItems();
            },
          ),
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
                  onFieldChanged: (String st) {
                    setState(() {});
                  },
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
            child: Consumer<OrderListProvider>(
              builder: (BuildContext context, OrderListProvider orderProvider,
                  Widget child) {
                return Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width / 2,
                  child: IndexedStack(
                      index: orderProvider.indexedStack,
                      children: <Widget>[
                        Container(
                          width: 600,
                          height: 450,
                          child: FlareActor("assets/images/analysis_new.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              isPaused: orderProvider.dataLoaded,
                              animation: "analysis"),
                        ),
                        if (orderProvider.dataLoaded)
                          GridView.count(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              primary: true,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              crossAxisCount: 5,
                              childAspectRatio: .7,
                              addRepaintBoundaries: true,
                              children: orderProvider.itemsList
                                  .where((SingleItem element) {
                                return element.name
                                    .trim()
                                    .toLowerCase()
                                    .contains(searchController.text
                                        .trim()
                                        .toLowerCase());
                              }).map((SingleItem item) {
                                return !getIt<OrderListProvider>()
                                        .selectedOptions
                                        .contains(item.id)
                                    ? Draggable<SingleItem>(
                                        childWhenDragging:
                                            childForDragging(item),
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
                                            CachedNetworkImage(
                                              imageUrl: item.image ?? "",
                                              progressIndicatorBuilder:
                                                  (BuildContext context,
                                                          String url,
                                                          DownloadProgress
                                                              downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget:
                                                  (BuildContext context,
                                                          String url,
                                                          dynamic error) =>
                                                      Icon(Icons.error),
                                            ),
                                            Material(
                                                color: Colors.transparent,
                                                textStyle:
                                                    styles.angrywhitestyle,
                                                child: Text(item.name)),
                                          ],
                                        ),
                                        child: childForDragging(item))
                                    : childForDragging(item);
                              }).toList())
                        else
                          Container()
                      ]),
                );
              },
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
                    if (indexedStackId == 1)
                      Container(
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
                              duration: const Duration(milliseconds: 900),
                              child: DottedBorder(
                                color: Colors.black,
                                borderType: BorderType.RRect,
                                strokeWidth: 2,
                                child: DragTarget<SingleItem>(
                                  onWillAccept: (SingleItem data) {
                                    return true;
                                  },
                                  onAccept: (SingleItem value) {
                                    setState(() {
                                      getIt<OrderListProvider>().addItemToList(
                                          value.id,
                                          value.name,
                                          value.notes,
                                          value.queantity,
                                          value.unit,
                                          value.unitPrice);
                                      getIt<OrderListProvider>()
                                          .selectedOptions
                                          .add(value.id);
                                      indexedStackId = 0;
                                      animatedHight = 0;
                                    });
                                  },
                                  onLeave: (dynamic value) {},
                                  builder: (BuildContext context,
                                      List<SingleItem> candidateData,
                                      List<dynamic> rejectedData) {
                                    print(candidateData);
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        color: Colors.transparent);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(),
                    if (getIt<OrderListProvider>().selectedOptions.isNotEmpty)
                      Consumer<OrderListProvider>(
                        builder: (BuildContext context, OrderListProvider value,
                            Widget child) {
                          return GridView.count(
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
                              children: value.ordersList
                                  .map((SingleItemForSend item) {
                                return Slidable(
                                    actionPane:
                                        const SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          setState(() {
                                            value.removeItemFromList(item.id);
                                            getIt<OrderListProvider>()
                                                .selectedOptions
                                                .remove(item.id);
                                          });
                                        },
                                      ),
                                    ],
                                    child: cartItem(item));
                              }).toList());
                        },
                      )
                    else
                      Container(),
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

  void showUnitDialog() {
    showGeneralDialog<dynamic>(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.73),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (BuildContext context, Animation<double> anim1,
          Animation<double> anim2) {
        return const UnitsCooficientsDialog();
      },
      transitionBuilder: (BuildContext context, Animation<double> anim1,
          Animation<double> anim2, Widget child) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget cartItem(SingleItemForSend item) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(8.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.name, style: styles.typeNameinOrderScreen),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: item.image ?? "",
                        progressIndicatorBuilder: (BuildContext context,
                                String url,
                                DownloadProgress downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                        errorWidget:
                            (BuildContext context, String url, dynamic error) =>
                                Icon(Icons.error),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue[700],
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {
                            getIt<OrderListProvider>()
                                .incrementQuantity(item.id);
                          },
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(item.queantity.toString(),
                              style: styles.mystyle),
                        ),
                        onTap: () {
                          showQuantityDialog(item.id);
                        },
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue[700],
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.remove),
                          color: Colors.white,
                          onPressed: () {
                            getIt<OrderListProvider>()
                                .decrementQuantity(item.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showUnitDialog();
                    },
                    child: Row(
                      children: <Widget>[
                        Text(item.unit,
                            style: styles.mystyle, textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(item.unitPrice,
                      style: styles.mystyle, textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(
                    "${double.parse(item.unitPrice) * item.queantity}",
                    style: styles.mystyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTotal() {
    return Consumer<OrderListProvider>(
        builder: (BuildContext context, OrderListProvider value, Widget child) {
      return Column(
        children: <Widget>[
          Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(trans(context, 'total') + " ",
                      style: styles.mywhitestyle),
                  Text(value.sumTotal.toString(), style: styles.mywhitestyle)
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
                    child: Text(trans(context, "draft"),
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
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pushNamed(context, "/Payment_Screen");
                    },
                    child: Text(trans(context, "order"),
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
                    color: Colors.red,
                    onPressed: () {
                      showDialog<dynamic>(
                          context: context,
                          builder: (_) => FlareGiffyDialog(
                                flarePath: 'assets/images/space_demo.flr',
                                flareAnimation: 'loading',
                                title: Text(
                                  trans(context, "are_u_sure_cancel"),
                                  textAlign: TextAlign.center,
                                  style: styles.underHeadblack,
                                ),
                                flareFit: BoxFit.cover,
                                entryAnimation: EntryAnimation.TOP,
                                onOkButtonPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  value.clearOrcerList();
                                },
                              ));
                    },
                    child: Text(trans(context, "cancel"),
                        style: styles.mywhitestyle),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  TextEditingController quantityController = TextEditingController();
  Future<dynamic> showQuantityDialog(int itemId) async {
    await showDialog<String>(
      context: context,
      builder: (_) => _SystemPadding(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: quantityController,
                  keyboardType: TextInputType.number,
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
                  getIt<OrderListProvider>()
                      .setQuantity(itemId, int.parse(quantityController.text));
                  quantityController.clear();
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  const _SystemPadding({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewPadding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
