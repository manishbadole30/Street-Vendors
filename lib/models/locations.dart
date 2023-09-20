import 'package:flutter/material.dart';

class Locations
{
  String? locationuid;
  String? locationname;
  String? location;
  String? locationemail;
  String? locationphotoUrl;

  Locations({
     required this.locationuid,
     required this.locationname,
     required this.location,
     required this.locationemail,
     required this.locationphotoUrl,
});

  Locations.fromJson(Map<String, dynamic> json)
  {
    locationuid = json["locationuid"];
    locationname = json["locationname"];
    location = json["location"];
    locationemail = json["locationemail"];
    locationphotoUrl = json["locationphotoUrl"];
  }
  Map<String, dynamic> toJson()
  {
    final Map<String,dynamic> data = new Map<String, dynamic>();
    data["locationuid"] = this.locationuid;
    data["locationname"] = this.locationname;
    data["location"] =   this.location;
    data["locationemail"] = this.locationemail;
    data["locationphotoUrl"] = this.locationphotoUrl;
    return data;
  }
}