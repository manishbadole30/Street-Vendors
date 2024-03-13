import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:street_vendors/global/global.dart';
import 'package:street_vendors/Search/search_screen.dart';

import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';

class MyDrawer extends StatelessWidget
{
  const MyDrawer({super.key});


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
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
          //header drawer
          Container(
            padding: const EdgeInsets.only(top: 26,bottom: 12),
            child: Column(
              children: [
                const SizedBox(height: 70,),
                Material(
                  borderRadius:  const BorderRadius.all(Radius.circular(100)),
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25,),
                Text(
                    sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),

           const SizedBox(height: 12,),

          //drawer body
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child:  Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                 ListTile(
                  leading: const Icon(Icons.home,
                    color: Colors.white,
                  ),
                  title:  const Text(
                    "Home",
                    style: TextStyle(color: Colors.white, fontSize: 19,),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>  const HomeScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.search,
                    color: Colors.white,
                  ),
                  title:  const Text(
                    "Search",
                    style: TextStyle(color: Colors.white, fontSize: 19,),
                  ),
                   onTap: ()
                   {
                     Navigator.push(context, MaterialPageRoute(builder: (c)=> const SearchScreen()));
                   },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title:  const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 19,),
                  ),
                  onTap: ()
                  {
                   _logout(context);
                  },
                ),


                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                const SizedBox(height: 150,),

                ListTile(
                  title:  const Text(
                    "  About Us",
                    style: TextStyle(
                        color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onTap: ()
                  {
                      // Navigator.push(context, MaterialPageRoute(builder: (c)=> const AboutUs()));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
