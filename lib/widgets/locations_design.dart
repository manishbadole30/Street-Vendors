import 'package:flutter/material.dart';
import 'package:street_vendors/mainScreens/shops_screen.dart';
import 'package:street_vendors/models/locations.dart';



class LocationsDesignWidget extends StatefulWidget
{
  Locations? model;
  BuildContext? context;

  LocationsDesignWidget({this.model, this.context});

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
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 6,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 3,),
              Image.network(
                widget.model!.locationphotoUrl!,
                height: 220.0,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2.0,),
              Text(
                widget.model!.location!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
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
