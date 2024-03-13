import 'package:flutter/material.dart';
import 'package:street_vendors/mainScreens/shop_detail_screen.dart';

import '../models/shops.dart';

// Shops screen, if user taps on this it will redirect to ShopsDetailScreen

class ShopsDesignWidget extends StatefulWidget
{
  Shops? model;
  BuildContext? context;

  ShopsDesignWidget({super.key, this.model, this.context});

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
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Divider(
                height: 0.0,
                thickness: 3,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 5,),

              Text(
                widget.model!.shopTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 2.5,),

              Image.network(
                widget.model!.shopUrl!,
                height: 220.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 3,),

              const Divider(
                height: 10,
                thickness: 6,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
