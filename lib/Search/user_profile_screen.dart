import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

//Completed UserProfileScreen used at 2 places, nav and homeAppbar COMPLETED

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? name = '';
  String? email = '';
  String? image = '';
  String? phoneNo = '';
  File? imageXFile;
  String? userNameInput = '';
  String? userImageUrl;


  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async
    {
       if(snapshot.exists)
         {
           setState(() {
             name = snapshot.data()!["userName"];
             email = snapshot.data()!["userEmail"];
             image = snapshot.data()!["userAvatarUrl"];
             phoneNo = snapshot.data()!["userphone"];
           });
         }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromDatabase();
  }

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
        imageXFile = File(croppedImage.path);
        _updateImageInFirestore();
      });
    }
  }

  Future _updateUserName() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'userName': userNameInput,
    });
  }

  _displayTextInputDialog(BuildContext context) async
  {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Your Name Here'),
            content: TextField(
              onChanged: (value)
              {
                setState(() {
                  userNameInput = value;
                });
              },
              decoration: const InputDecoration(hintText: "Type here"),
            ),
            actions: [
              ElevatedButton(
                onPressed: ()
                {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.white,),),
              ),
              ElevatedButton(
                onPressed: ()
                {
                  _updateUserName();
                  updateProfileNameOnUserExistingUploadImage();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white,),),
              ),
            ],
          );
        }
    );
  }

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

  void _updateImageInFirestore() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref()
        .child("users").child(fileName);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) async {
      userImageUrl = url;
    });
    
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
        {
          'userAvatarUrl': userImageUrl,
        }).whenComplete(()
     {
       updateProfileImageOnUserExistingUploadImage();
     });
  }

  updateProfileImageOnUserExistingUploadImage () async
  {
    await FirebaseFirestore.instance.collection('userUpload')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot)
      {
         for(int index = 0; index<snapshot.docs.length; index++)
           {
             String userProfileImageInUploadImage = snapshot.docs[index]['userImage'];

             if(userProfileImageInUploadImage != userImageUrl)
               {
                  FirebaseFirestore.instance.collection('userUpload')
                      .doc(snapshot.docs[index].id)
                      .update(
                      {
                        'userImage': userImageUrl,
                      });
               }
           }
      });
  }

  updateProfileNameOnUserExistingUploadImage () async
  {
    await FirebaseFirestore.instance.collection('userUpload')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot)
    {
      for(int index = 0; index<snapshot.docs.length; index++)
      {
        String userProfileNameInUploadImage = snapshot.docs[index]['name'];

        if(userProfileNameInUploadImage != userNameInput)
        {
          FirebaseFirestore.instance.collection('userUpload')
              .doc(snapshot.docs[index].id)
              .update(
              {
                'name': userNameInput,
              });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepOrange.shade300,],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade400,
        title: const Center(
          child: Text(
            ' My Profile Screen',
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
            ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.deepOrange.shade300,],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
               _showImageDialog();
              },
              child: CircleAvatar(
                backgroundColor: Colors.amberAccent,
                minRadius: 95.0,
                child: CircleAvatar(
                  radius: 90.0,
                  backgroundImage: imageXFile == null
                    ?
                      NetworkImage(
                        image!,
                      )
                      :
                      Image.file
                        (imageXFile!).image,
                ),
              ),
            ),

            const SizedBox(height: 22.0,),

           Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name : ${name!}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _displayTextInputDialog(context);
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10.0,),

            Text(
              'Email : ${email!}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20.0,),

            Text(
              'Phone Number :  ${phoneNo!}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25.0,),

            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10,),
              ),
              child: const Text(
                  "Logout",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
