import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:street_vendors/authentication/auth_screen.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';
import 'package:street_vendors/Search/search_screen.dart';
import 'package:street_vendors/upload/user_image_upload_screen.dart';

import '../Search/user_profile_screen.dart';
import '../global/global.dart';

// 5 Buttons in nav bar All Done COMPLETED

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavigationBarForApp({super.key, required this.indexNum});

  void _logout(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context)
        {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                      Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to Log Out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('No', style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold,letterSpacing: 1,),),
              ),
              TextButton(
                onPressed: () {
                  firebaseAuth.signOut().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
                  });
                },
                child: const Text('Yes', style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1,),),
              ),
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.pinkAccent.shade100,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 46,
      index: indexNum,
      items: const [
        Icon(Icons.home_rounded, size: 19, color: Colors.black,),
        Icon(Icons.search, size: 19, color: Colors.black,),
        Icon(Icons.add, size: 19, color: Colors.black,),
        Icon(Icons.person_pin, size: 19, color: Colors.black,),
        Icon(Icons.exit_to_app, size: 19, color: Colors.black,),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index)
      {
        if(index == 0)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        else if(index == 1)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
          }
        else if(index == 2)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UploadScreen()));
        }
        else if(index == 3)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        }
        else if(index == 4)
        {
          _logout(context);
        }
      },
    );
  }
}
