import 'package:agent_second/models/transactions.dart';
import 'package:agent_second/providers/export.dart';
import 'package:agent_second/util/service_locator.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class AgentOrders extends StatefulWidget {
  const AgentOrders({Key key}) : super(key: key);

  @override
  _AgentOrdersState createState() => _AgentOrdersState();
}

class _AgentOrdersState extends State<AgentOrders> {
  @override
  void initState() {
    super.initState();
    getIt<TransactionProvider>().pagewiseAgentOrderController =
        PagewiseLoadController<dynamic>(
            pageSize: 15,
            pageFuture: (int pageIndex) async {
              return getIt<TransactionProvider>()
                  .getAgentOrderTransactions(pageIndex, 1);
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: PagewiseListView<dynamic>(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            pageLoadController:
                getIt<TransactionProvider>().pagewiseAgentOrderController,
            itemBuilder: (BuildContext context, dynamic obj, int index) {
              return AnimatedCard(
                direction: AnimatedCardDirection.left,
                initDelay: const Duration(milliseconds: 0),
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
                child: agentTransactionBuilder(context, obj as Transaction,index),
              );
            }));
  }

  Widget agentTransactionBuilder(
      BuildContext context, Transaction obj, int index) {
    return Container();
  }
}
