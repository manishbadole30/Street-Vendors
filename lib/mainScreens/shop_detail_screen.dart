import 'package:flutter/material.dart';
import 'package:street_vendors/models/shops.dart';
import 'package:street_vendors/widgets/app_bar.dart';

class ShopDetailsScreen extends StatefulWidget
{
  final Shops? model;
  ShopDetailsScreen({this.model});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: MyAppBar(),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                widget.model!.shopUrl.toString(),
                width: MediaQuery.of(context).size.width *3,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.shopTitle.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.shopInfo.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Opening and Closing Time : ${widget.model!.shopTiming}",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Contact Info : ${widget.model!.shopContactInfo}",
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Price : ₹ ${widget.model!.shopAvgPrice}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: InkWell(
                onTap: ()
                {
                  //Comment Functionality
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.amber,
                        ],
                        begin:  FractionalOffset(0.0, 0.0),
                        end:  FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width -13,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Add a Comment",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
