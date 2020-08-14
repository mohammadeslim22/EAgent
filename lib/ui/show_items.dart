import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/Items.dart';
import 'package:agent_second/models/ben.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:agent_second/widgets/text_form_input.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/src/result/download_progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  Widget childForDragging(
      SingleItem item, OrderListProvider orsderListProvider) {
    print("single item in order screen ${item.id}");
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(8.0)),
      color: getIt<OrderListProvider>().selectedOptions.contains(item.id)
          ? Colors.grey
          : Colors.white,
      child: InkWell(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 4),
            CachedNetworkImage(
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              imageUrl: (item.image != "null")
                  ? "http://edisagents.altariq.ps/public/image/${item.image}"
                  : "",
              progressIndicatorBuilder: (BuildContext context, String url,
                      DownloadProgress downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (BuildContext context, String url, dynamic error) =>
                  const Icon(Icons.error),
            ),
            Text(
              item.name,
              style: styles.smallItembluestyle,
              textAlign: TextAlign.center,
            ),
            Text(item.unitPrice.toString(), style: styles.mystyle),
            const Spacer(),
            Text(item.balanceInventory.toString(), style: styles.balanceInventory),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (getIt<OrderListProvider>().dataLoaded) {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                              crossAxisCount: 10,
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
                                return childForDragging(item, orderProvider);
                              }).toList())
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
