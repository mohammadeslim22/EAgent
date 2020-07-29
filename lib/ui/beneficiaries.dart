import 'package:agent_second/constants/colors.dart';
import 'package:agent_second/constants/styles.dart';
import 'package:agent_second/localization/trans.dart';
import 'package:agent_second/models/ben.dart';
import 'package:agent_second/providers/global_variables.dart';
import 'package:agent_second/widgets/global_drawer.dart';
import 'package:agent_second/widgets/text_form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
class Beneficiaries extends StatefulWidget {
  const Beneficiaries({Key key}) : super(key: key);

  @override
  _BeneficiariesState createState() => _BeneficiariesState();
}

class _BeneficiariesState extends State<Beneficiaries> {
  Set<int> selectedOptions = <int>{};
  BeneficiariesModel beneficiaries;

  //List<int> specializations = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final GlobalVars globalVarsProv =
              Provider.of<GlobalVars>(context, listen: false);
    beneficiaries = globalVarsProv.beneficiaries;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalVars globalVarsProv =
              Provider.of<GlobalVars>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "altriq")),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            width: 300,
            child: TextFormInput(
              text: trans(context, 'ben_name'),
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
      drawer: GlobalDrawer(sourceContext: context),
      body: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 3,
          childAspectRatio: 2,
          addRepaintBoundaries: true,
          children: beneficiaries.data.map((Ben item) {
            return Card(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (selectedOptions.contains(item.id)) {
                      selectedOptions.clear();
                    } else {
                      selectedOptions.clear();
                      selectedOptions.add(item.id);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(item.id.toString(), style: styles.beneficires),
                              const SizedBox(
                                height: 32,
                              ),
                              IconButton(
                                icon: Icon(Icons.phone_forwarded),
                                color: Colors.green,
                                onPressed: () {},
                              )
                            ],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                          item.name,
                                          style: styles.beneficiresNmae),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(item.address,
                                        style: styles.underHeadgray),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Text("رقم التواصل:  ",
                                    //     style: styles.underHeadgray),
                                    Text(item.phone,
                                        style: styles.underHeadgray),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SvgPicture.asset("assets/images/visitedsign.svg"),
                        ],
                      ),
                      const Divider(),
                      if (selectedOptions.contains(item.id))
                        Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                        "assets/images/orderButton.svg",
                                        height: 90),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                        "assets/images/returnButton.svg",
                                        height: 90),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                        "assets/images/collectionButton.svg",
                                        height: 90),
                                  )
                                ],
                              )),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.blue)),
                            onPressed: () async {
                              globalVarsProv.setBenInFocus(item);
                              Navigator.pushNamed(
                                  context, "/Beneficiary_Center",
                                  arguments: <String, Ben>{"ben": item});
                            },
                            color: colors.myBlue,
                            textColor: colors.white,
                            child: Text(trans(context, 'view_more')),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}
