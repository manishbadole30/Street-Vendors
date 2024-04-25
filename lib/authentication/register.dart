import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_vendors/authentication/auth_screen.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';
import 'package:street_vendors/widgets/custom_text_field.dart';
import 'package:street_vendors/widgets/loading_dialog.dart';

import '../global/global.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


// This is Register Screen not Auth Screen COMPLETED

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();


  XFile? imageXFile;

  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = "";

  // Future<void> _getImage() async
  // {
  //     imageXFile = await _picker.pickImage(source: ImageSource.gallery);
  //
  //     setState(() {
  //       imageXFile;
  //     });
  // }

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
        imageXFile = XFile(croppedImage.path);
      });
    }
  }


  Future<void> formValidation() async
  {
    if(imageXFile == null)
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please select an image.",
              );
            }
        );
      }
    else
      {
        if(passwordcontroller.text == confirmPasswordcontroller.text)
          {
            if(confirmPasswordcontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty &&phonecontroller.text.isNotEmpty)
              {
                //start uploading image
                showDialog(
                    context: context,
                    builder: (c)
                    {
                       return LoadingDialog(
                         message: "Registering Account",
                       );
                    }
                );

                String fileName = DateTime.now().millisecondsSinceEpoch.toString();
                fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
                fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
                fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                await taskSnapshot.ref.getDownloadURL().then((url) {
                  sellerImageUrl = url;

                  //save info to firestore
                  authenticateUserAndSignUp();

                });
              }
            else
              {
                showDialog(
                  context: context,
                  builder: (c)
                  {
                    return ErrorDialog(
                      message: "Please write the complete required info for Registration.",
                    );
                  }
              );
              }
          }
        else
          {
            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "Password do not match.",
                  );
                }
            );
          }
      }
  }

  void authenticateUserAndSignUp() async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
    ).then((auth) {
       currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });

    if(currentUser !=null)
      {
        saveDataToFirestore(currentUser!).then((value) {
          Navigator.pop(context);
          //send user to homepage
          Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        });
      }
  }

  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "userUID": currentUser.uid,
      "userEmail":currentUser.email,
      "userName":namecontroller.text.trim(),
      "userPassword":passwordcontroller.text.trim(),
      "userAvatarUrl":sellerImageUrl,
      "userphone":phonecontroller.text.trim(),
      "status": "approved",
      "createdAt": Timestamp.now(),
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", namecontroller.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 10,),
         InkWell(
           onTap: ()
           {
             // _getImage();
             _showImageDialog();
           },
           child: CircleAvatar(
             radius: MediaQuery.of(context).size.width * 0.20,
             backgroundColor: Colors.white,
             backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
             child: imageXFile == null ?
             Icon(
               Icons.add_photo_alternate,
               size: MediaQuery.of(context).size.width * 0.20,
               color: Colors.grey,
             ) : null ,
           ),
         ),
          const SizedBox(height: 10,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: namecontroller,
                  hintText: "Name",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.email,
                  controller: emailcontroller,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordcontroller,
                  hintText: "Password",
                  isObsecre: true,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: confirmPasswordcontroller,
                  hintText: "Confirm Password",
                  isObsecre: true,
                ),
                CustomTextField(
                  data: Icons.phone,
                  controller: phonecontroller,
                  hintText: "Phone",
                  isObsecre: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
            ),
            onPressed: () {
              formValidation();
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2),
            ),
          ),

          const SizedBox(height: 8,),


          Row(
            children: [
              const Expanded(
                child: Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
                  },
                  child:  const Text(
                    ' Login ',
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5,),

        ],
      ),
    );
  }
}
