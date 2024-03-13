import 'package:flutter/material.dart';
import 'package:street_vendors/models/shops.dart';
import 'package:street_vendors/widgets/app_bar.dart';


// This is shopfulldetails screen or final screen of our app

class ShopDetailsScreen extends StatefulWidget
{

  final Shops? model;

  const ShopDetailsScreen({super.key, this.model});


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
            const Padding(padding: EdgeInsets.all(2),),
            Image.network(
                widget.model!.shopUrl.toString(),
                width: MediaQuery.of(context).size.width *3,
            ),

            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text(
                widget.model!.shopTitle.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.model!.shopInfo.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Opening and Closing Time : ${widget.model!.shopTiming}",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Contact Info : ${widget.model!.shopContactInfo}",
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Price : ₹ ${widget.model!.shopAvgPrice}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: InkWell(
                onTap: ()
                {
                  //Comment Functionality to add
                },
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  margin: const EdgeInsets.only(left: 30, top: 0.0, right: 30,bottom: 0),
                  child: const Center(
                    child: Text(
                      "Add a Comment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25,),

          ],
        ),
      ),
    );
  }
}
