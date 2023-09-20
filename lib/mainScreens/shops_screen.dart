import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:street_vendors/models/locations.dart';
import 'package:street_vendors/widgets/app_bar.dart';
import 'package:street_vendors/widgets/shops_design.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';
import '../models/shops.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';


class ShopsScreen extends StatefulWidget
{
  final Locations? model;
  ShopsScreen({this.model});

  @override
  _ShopsScreenState createState() => _ShopsScreenState();
}



class _ShopsScreenState extends State<ShopsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: MyAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true,delegate: TextWidgetHeader(title: widget.model!.location.toString() + " Shops")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("locations")
                .doc(widget.model!.locationuid)
                .collection("shops")
                .orderBy("publishedDate", descending:true)
                .snapshots(),
            builder: (context,snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c)=> StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Shops model = Shops.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return ShopsDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          )
        ],
      ),
    );
  }
}
