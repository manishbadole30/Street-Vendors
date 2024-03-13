import 'package:flutter/material.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';

// Currently No Use of This Screen But Before used as HomeScreen actions(RightSide)
// No Working

class NotificationsAppBar extends StatefulWidget {
  const NotificationsAppBar({super.key});

  @override
  State<NotificationsAppBar> createState() => _NotificationsAppBarState();
}

class _NotificationsAppBarState extends State<NotificationsAppBar> {
  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 26,
            fontFamily: "Varela",
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          },
        ),
      ),
      body: Container(
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'OOPS!! \n '
                'No New Notifications Yet!!!',
                style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return defaultScreen();
  }
}
