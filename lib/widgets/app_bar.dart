import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget
{

  final PreferredSizeWidget? bottom;
  MyAppBar({super.key, this.bottom});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);


}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context)
  {
    return AppBar(
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
      title: const Text(
        "Street Vendors",
        style: TextStyle(fontSize: 38, color:Colors.white,fontFamily: "Signatra"),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }
}
