import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:street_vendors/authentication/auth_screen.dart';
import 'package:street_vendors/global/global.dart';
import 'package:street_vendors/mainScreens/home_screen.dart';
import 'package:street_vendors/widgets/error_dialog.dart';
import 'package:street_vendors/widgets/loading_dialog.dart';

import '../ForgetPassword/forget_password_screen.dart';
import '../widgets/custom_text_field.dart';

//This is Login Screen not AuthScreen COMPLETED

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();


  formValidation()
  {
    if(emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty)
      {
        //login
        loginNow();
      }
    else
      {
        showDialog(
          context: context,
          builder: (c)
            {
              return ErrorDialog(
                message: "Please write email and password",
              );
            }
        );
      }
  }

  loginNow() async
  {
    showDialog(
        context: context,
        builder: (c)
        {
          return LoadingDialog(
            message: "Checking Credentials",
          );
        }
    );

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    ).then((auth){
      currentUser = auth.user!;
    }).catchError((error) {
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
    if(currentUser != null)
      {
        readDataAndSetDataLocally(currentUser!);
      }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).get().then((snapshot) async {
      if(snapshot.exists)
        {
          await sharedPreferences!.setString("uid",currentUser.uid);
          await sharedPreferences!.setString("email",snapshot.data()!["userEmail"]);
          await sharedPreferences!.setString("name",snapshot.data()!["userName"]);
          await sharedPreferences!.setString("photoUrl",snapshot.data()!["userAvatarUrl"]);

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
        }
        else
          {
            firebaseAuth.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "No record Found",
                  );
                }
            );
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                  "images/panipuri.jpg",
                  height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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

                const SizedBox(height: 2,),

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: ()
                    {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                    },
                    child: const Text(
                      'Forget password?  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6,),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
            ),
            onPressed: ()
            {
              formValidation();
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),
            ),
          ),

          const SizedBox(height: 10,),

        ],
      ),
    );
  }
}
