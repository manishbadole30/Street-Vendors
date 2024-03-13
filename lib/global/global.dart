import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

String forgetUrlImage = 'https://images.pexels.com/photos/9578527/pexels-photo-9578527.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';