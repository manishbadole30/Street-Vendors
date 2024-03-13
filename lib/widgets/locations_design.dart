import 'package:flutter/material.dart';
import 'package:street_vendors/mainScreens/shops_screen.dart';
import 'package:street_vendors/models/locations.dart';

//Location Page or Home Page Functionality

class LocationsDesignWidget extends StatefulWidget
{
  Locations? model;
  BuildContext? context;

  LocationsDesignWidget({super.key, this.model, this.context});

  @override
  _LocationsDesignWidgetState createState() => _LocationsDesignWidgetState();
}


class _LocationsDesignWidgetState extends State<LocationsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ShopsScreen(model: widget.model)));
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

              Image.network(
                widget.model!.locationphotoUrl!,
                height: 220.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 2.5,),

              Text(
                widget.model!.location!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Train",
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 3,),

              // Divider(
              //   height: 6,
              //   thickness: 3,
              //   color: Colors.redAccent,
              // ),

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
