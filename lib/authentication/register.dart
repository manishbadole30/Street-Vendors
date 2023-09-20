import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';
import 'package:street_vendors/widgets/custom_text_field.dart';
import 'package:street_vendors/widgets/loading_dialog.dart';

import '../global/global.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

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

  Future<void> _getImage() async
  {
      imageXFile = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        imageXFile;
      });
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
          Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
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
      "userstatus":"approved",
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
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
           InkWell(
             onTap: ()
             {
               _getImage();
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
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationcontroller,
                    hintText: "Street Address",
                    isObsecre: false,
                    enabled: false,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get my Current Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: ()=> print("clicked"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
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
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
