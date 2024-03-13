import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:street_vendors/models/locations.dart';
import 'package:street_vendors/widgets/bottom_nav_bar.dart';

import '../mainScreens/home_screen.dart';
import '../widgets/locations_design.dart';

//Search Screen in Navbar COMPLETED

class SearchScreen extends StatefulWidget
{
  const SearchScreen({super.key});



  @override
  State<SearchScreen> createState() => _SearchScreenState();
}



class _SearchScreenState extends State<SearchScreen> 
{
  Future<QuerySnapshot>? locationsDocumentsList;

  String locationText = '';

  initSearchingLocation(String textEntered)
  {
    locationsDocumentsList = FirebaseFirestore.instance
        .collection("locations")
        .where("location", isGreaterThanOrEqualTo: textEntered)
        .get();

    setState(() {
      locationsDocumentsList;
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: ()
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        flexibleSpace: Container(
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
        ),
        title: TextField(
          onChanged: (textEntered)
          {
            setState(() {
              locationText = textEntered;
            });
            //init search
            initSearchingLocation(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Location here...",
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 20),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: ()
              {
                initSearchingLocation(locationText);
              },
            )
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: locationsDocumentsList,
        builder: (context, snapshot)
        {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index)
                  {
                    Locations model = Locations.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>
                    );

                    return LocationsDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                )
              : const Center(child: Text("No Results Found"),);
        },
      ),
    );
  }
}
