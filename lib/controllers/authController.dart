import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isloading = false.obs;
  RxBool hidepass = true.obs;

  //  Google Signin
  Future<void> handleGoogleSignIn() async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(credential);
        // Listen for Firebase authentication state changes
        auth.authStateChanges().listen((User? firebaseUser) async {
          if (firebaseUser == null) {
            BotToast.showText(text: "No user available");
          } else {
            await usersCollection.doc(firebaseUser.uid).set({
              'userid': firebaseUser.uid,
              'email': firebaseUser.email,
              'username': '',
              'userpic': null
            });
            GetStorage().write("userid", firebaseUser.uid);
            GetStorage().write("username", firebaseUser.displayName);
            // Get.offAll(const BottomsNavigation());
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (error) {
      print(error);
      BotToast.showText(text: "Error Signing In");
    }
  }

  // Email Pass Sign In
  Future<void> handleLoginwithEmailPass(String email, String password) async {
    try {
      isloading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // Listen for Firebase authentication state changes
      auth.authStateChanges().listen((User? firebaseUser) {
        if (firebaseUser == null) {
          BotToast.showText(text: "No user available");
        } else {
          GetStorage().write("userid", firebaseUser.uid);
          GetStorage().write("useremail", email);
          isloading.value = false;
          // Get.offAll(const BottomsNavigation());
        }
      });
    } on SocketException {
      isloading.value = false;
      BotToast.showText(text: "Network Error");
    } on FirebaseAuthException catch (error) {
      isloading.value = false;
      BotToast.showText(text: "Sign up failed: ${error.message.toString()}");
    }
  }

  // Email Pass Sign Up
  Future<void> handleSignUpwithEmailPass(String email, String password) async {
    try {
      isloading.value = true;
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Listen for Firebase authentication state changes
      auth.authStateChanges().listen((User? firebaseUser) async {
        if (firebaseUser == null) {
          BotToast.showText(text: "Sign up failed");
        } else {
          // Store user data in Firestore
          await usersCollection.doc(firebaseUser.uid).set({
            'userid': firebaseUser.uid,
            'email': email,
            'username': '',
            'userpic': null
          });
          isloading.value = false;
          GetStorage().write("userid", firebaseUser.uid);
          GetStorage().write("useremail", email);
          // Get.offAll(const BottomsNavigation());
        }
      });
    } on SocketException {
      isloading.value = false;
      BotToast.showText(text: "Network Error");
    } on FirebaseAuthException catch (error) {
      isloading.value = false;
      BotToast.showText(text: "Sign up failed: ${error.message.toString()}");
    }
  }
}
