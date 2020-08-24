import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/Items.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:agent_second/widgets/text_form_input.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agent_second/providers/order_provider.dart';

class ShowItems extends StatefulWidget {
  const ShowItems({Key key}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<ShowItems> {
  int indexedStackId = 0;

  double animatedHight = 0;

  final TextEditingController searchController = TextEditingController();
  Map<String, String> itemsBalances = <String, String>{};
  List<int> prices = <int>[];

  Widget childForDragging(SingleItem item) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(8.0)),
      color: item.id % 2 == 1 ? colors.white : colors.grey,
      child: InkWell(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const SizedBox(width: 320),
          Text(item.name, style: styles.bluestyle, textAlign: TextAlign.start),
          const Spacer(),
          Text(item.shipmentBalance.toString(),
              style: styles.bluestyle, textAlign: TextAlign.start),
          const SizedBox(width: 320)
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    if (getIt<OrderListProvider>().itemsDataLoaded) {
    } else {
      getIt<OrderListProvider>().indexedStack = 0;
      getIt<OrderListProvider>().getItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colors.blue,
        title: Text(trans(context, "altariq")),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, size: 32),
            onPressed: () {
              getIt<OrderListProvider>().getItems();
            },
          ),
          Row(
            children: <Widget>[
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
                  child: IndexedStack(
                      index: orderProvider.indexedStack,
                      children: <Widget>[
                        Container(
                          child: FlareActor("assets/images/analysis_new.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              isPaused: orderProvider.itemsDataLoaded,
                              animation: "analysis"),
                        ),
                        if (orderProvider.itemsDataLoaded)
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderProvider.itemsList.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                if (orderProvider.itemsList[index].name
                                    .trim()
                                    .toLowerCase()
                                    .contains(searchController.text
                                        .trim()
                                        .toLowerCase()))
                                  return childForDragging(
                                      orderProvider.itemsList[index]);
                                else
                                  return Container();
                              })
                        else
                          Container()
                      ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
