import 'dart:async';

import 'package:flutter/material.dart';
import 'package:street_vendors/authentication/auth_screen.dart';
import 'package:street_vendors/global/global.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}


class _MySplashScreenState extends State<MySplashScreen>
{
  startTimer()
  {
      Timer(const Duration(seconds: 3), () async {
      //if user is already loggedIn
      if(firebaseAuth.currentUser!= null) {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      }
      //if user is not loggedIn
      else
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
        }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.teal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset(
              "images/splash.jpg",
            ),
          ),

            const SizedBox(height: 10,),

            const Text(
               'Welcome To !!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                letterSpacing: 2,
              ),),

            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "Street Vendors Location",
               textAlign: TextAlign.center,
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 40,
                 fontFamily: "Signatra",
                 letterSpacing: 2.5,
               ),
           ),
            ),
        ],
      )
    );
  }
}
