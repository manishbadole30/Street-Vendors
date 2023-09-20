import 'package:flutter/material.dart';
import 'package:street_vendors/mainScreens/shop_detail_screen.dart';

import '../models/shops.dart';



class ShopsDesignWidget extends StatefulWidget
{
  Shops? model;
  BuildContext? context;

  ShopsDesignWidget({this.model, this.context});

  @override
  _ShopsDesignWidgetState createState() => _ShopsDesignWidgetState();
}



class _ShopsDesignWidgetState extends State<ShopsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ShopDetailsScreen(model: widget.model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 1,),
              Text(
                widget.model!.shopTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              const SizedBox(height: 2,),
              Image.network(
                widget.model!.shopUrl!,
                height: 220.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2.0,),
              Divider(
                height: 6,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
