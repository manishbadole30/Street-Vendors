import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:street_vendors/upload/user_image_upload_screen.dart';
import 'package:street_vendors/widgets/button_square.dart';

//Owner Details Page COMPLETED

class OwnerDetails extends StatefulWidget {

  String? img;
  String? userImg;
  String? name;
  DateTime? date;
  String? docId;
  String? userId;
  int? downloads;

  OwnerDetails({
    super.key,
    this.img,
    this.userImg,
    this.name,
    this.date,
    this.docId,
    this.userId,
    this.downloads,
  });

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.deepOrange.shade300,],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.red,
                  child: Column(
                    children: [
                      Image.network(
                        widget.img!,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 23.0,),

                const Text(
                  'Owner Information',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 14.0,),

                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.userImg!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 10.0,),

                Text(
                  'Uploaded by:  ${widget.name!}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10.0,),

                Text(
                  DateFormat("dd MMMM, yyyy - hh:mm a").format(widget.date!).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 28.0,),

               FirebaseAuth.instance.currentUser!.uid == widget.userId
                ?
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
                       child: ButtonSquare(
                         text: "Delete",
                         colors1: Colors.green,
                         colors2: Colors.lightGreen,

                         press: () async
                         {
                            FirebaseFirestore.instance.collection('userUpload')
                                .doc(widget.docId).delete()
                                .then((value)
                            {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const UploadScreen()));
                            });
                         }
                       ),
                   )
                   :
                   Container(),

                 Padding(
                   padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
                   child: ButtonSquare(
                       text: "Go Back",
                       colors1: Colors.green,
                       colors2: Colors.lightGreen,

                       press: () async
                       {
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const UploadScreen()));
                       }
                   ),
                 ),

                const SizedBox(height: 15.0,)

              ],
            ),
          ],
        ),
      ),
    );
  }
}
