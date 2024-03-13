import 'package:cloud_firestore/cloud_firestore.dart';

class Shops
{
  String? shopID;
  String? locationUID;
  String? shopTitle;
  String? shopInfo;
  String? shopTiming;
  String? shopAvgPrice;
  int? shopContactInfo;
  Timestamp? publishedDate;
  String? shopUrl;
  String? status;

  Shops({
    required this.shopID,
    required this.locationUID,
    required this.shopTitle,
    required this.shopInfo,
    required this.shopTiming,
    required this.shopAvgPrice,
    required this.shopContactInfo,
    required this.publishedDate,
    required this.shopUrl,
    required this.status,
  });

  Shops.fromJson(Map<String, dynamic> json)
  {
    shopID = json["shopID"];
    locationUID = json["locationUID"];
    shopTitle = json["shopTitle"];
    shopInfo = json["shopInfo"];
    shopTiming = json["shopTiming"];
    shopAvgPrice = json["shopAvgPrice"];
    shopContactInfo = json["shopContactInfo"];
    publishedDate = json["publishedDate"];
    shopUrl = json["shopUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["shopID"] = shopID;
    data["locationUID"] = locationUID;
    data["shopTitle"] = shopTitle;
    data["shopInfo"] = shopInfo;
    data["shopTiming"] = shopTiming;
    data["shopAvgPrice"] = shopAvgPrice;
    data["shopContactInfo"] = shopContactInfo;
    data["publishedDate"] = publishedDate;
    data["shopUrl"] = shopUrl;
    data["status"] = status;

    return data;
  }
}