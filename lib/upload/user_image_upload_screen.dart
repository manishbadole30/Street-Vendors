import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:street_vendors/owner_details/owner_details.dart';

import '../mainScreens/home_screen.dart';
import '../widgets/bottom_nav_bar.dart';

//user upload image screen COMPLETED

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  
  String changeTitle = "Grid View";
  bool checkView = false;

  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Please choose an option",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.red,),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.red,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void _getFromCamera() async
  {
    XFile? pickedFile =  await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async
  {
    XFile? pickedFile =  await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async
  {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath, maxHeight: 1080, maxWidth: 1080,);

    if(croppedImage != null)
    {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _upload_image() async
  {
    if(imageFile == null)
      {
        Fluttertoast.showToast(msg: "Please select an Image",);
        return;
      }
    try
     {
       final ref = FirebaseStorage.instance.ref().child('user_upload_images').child(DateTime.now().toString() + 'jpg');
       await ref.putFile(imageFile!);
       imageUrl = await ref.getDownloadURL();
       FirebaseFirestore.instance.collection('userUpload').doc(DateTime.now().toString()).set({
         'id': _auth.currentUser!.uid,
         'userImage': myImage,
         'name': myName,
         'email': _auth.currentUser!.email,
         'UploadImage': imageUrl,
         'downloads': 0,
         'createdAt': DateTime.now(),
       });
       Navigator.canPop(context) ? Navigator.pop(context) : null;
       imageFile = null;
     }
    catch(error)
    {
      Fluttertoast.showToast(msg: error.toString());
    }
  }
  
  void read_userInfo() async
  {
    FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then<dynamic>((DocumentSnapshot snapshot) async 
    {
      myImage = snapshot.get('userAvatarUrl');
      myName = snapshot.get('userName');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read_userInfo();
  }

   Widget listViewWidget (String docId, String img, String userImg, String name, DateTime date, String userId, int downloads,)
   {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Card(
         elevation: 16.0,
         shadowColor: Colors.white,
         child: Container(
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [Colors.pink, Colors.deepOrange.shade300,],
               begin: Alignment.centerLeft,
               end: Alignment.centerRight,
               stops: const [0.2, 0.9],
             ),
           ),
           padding: const EdgeInsets.all(5.0),
           child: Column(
             children: [
               GestureDetector(
                 onTap: ()
                 {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => OwnerDetails(
                     img: img,
                     userImg: userImg,
                     name: name,
                     date: date,
                     docId: docId,
                     userId: userId,
                     downloads: downloads,
                   )));
                 },
                 child: Image.network(
                     img,
                 fit: BoxFit.cover,
                 ),
               ),

               const SizedBox(height: 15.0,),

               Padding(
                 padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0,),
                 child: Row(
                   children: [
                     CircleAvatar(
                       radius: 35,
                       backgroundImage: NetworkImage(
                         userImg,
                       ),
                     ),

                     const SizedBox(width: 10.0,),

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           name,
                           style: const TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                           ),
                         ),

                         const SizedBox(height: 10.0,),

                         Text(
                           DateFormat("dd MMMM, yyyy - hh:mm a").format(date).toString(),
                           style: const TextStyle(
                             color: Colors.white54,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

  Widget gridViewWidget (String docId, String img, String userImg, String name, DateTime date, String userId, int downloads,)
  {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(6.0),
      crossAxisSpacing: 1,
      crossAxisCount: 1,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepOrange.shade300,],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9],
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: ()
            {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => OwnerDetails(
                img: img,
                userImg: userImg,
                name: name,
                date: date,
                docId: docId,
                userId: userId,
                downloads: downloads,
              )));
            },
            child: Center(
              child: Image.network(img, fit: BoxFit.fill,),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.deepOrange.shade300,],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: "1",
                backgroundColor: Colors.deepOrange.shade400,
                onPressed: () {
                  _showImageDialog();
                },
                child: const Icon(Icons.camera_enhance_sharp, color: Colors.white,),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: "2",
                backgroundColor: Colors.pink.shade400,
                onPressed: () {
                  _upload_image();
                },
                child: const Icon(Icons.cloud_upload, color: Colors.white,),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.pink,],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () 
            {
              setState(() {
                changeTitle = 'List View';
                checkView = true;
              });
            },
            onDoubleTap: () {
              setState(() {
                changeTitle = 'Grid View';
                checkView = false;
              });
            },
            child: Text(changeTitle,style: const TextStyle(color: Colors.white,),),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('userUpload').orderBy("createdAt", descending: true,).snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
             if(snapshot.connectionState == ConnectionState.waiting)
             {
               return const Center(child: CircularProgressIndicator(),);
             }
             else if(snapshot.connectionState == ConnectionState.active)
             {
               if(snapshot.data!.docs.isNotEmpty)
               {
                 if(checkView == true)
                 {
                   return ListView.builder(
                     itemCount: snapshot.data!.docs.length,
                     itemBuilder: (BuildContext context, int index)
                     {
                       return listViewWidget(
                         snapshot.data!.docs[index].id,
                         snapshot.data!.docs[index]['UploadImage'],
                         snapshot.data!.docs[index]['userImage'],
                         snapshot.data!.docs[index]['name'],
                         snapshot.data!.docs[index]['createdAt'].toDate(),
                         snapshot.data!.docs[index]['id'],
                         snapshot.data!.docs[index]['downloads'],
                       );
                     }
                   );
                 }
                 else
                 {
                   return GridView.builder(
                       itemCount: snapshot.data!.docs.length,
                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 2,
                       ),
                       itemBuilder: (BuildContext context, int index)
                       {
                         return gridViewWidget(
                           snapshot.data!.docs[index].id,
                           snapshot.data!.docs[index]['UploadImage'],
                           snapshot.data!.docs[index]['userImage'],
                           snapshot.data!.docs[index]['name'],
                           snapshot.data!.docs[index]['createdAt'].toDate(),
                           snapshot.data!.docs[index]['id'],
                           snapshot.data!.docs[index]['downloads'],
                         );
                       }
                   );
                 }
               }
               else
               {
                 return const Center(
                   child: Text('There is no tasks',
                     style: TextStyle(
                       fontSize: 20,
                     ),),
                 );
               }
             }
             return const Center(
               child: Text('Something went wrong',
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 30,
               ),
               ),
             );
          },
        ),
      ),
    );
  }
}
