import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _submitAuthForm(
      String email,
      String password,
      String username,
      File? image,
      bool isLogin,
      BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child('user_image').child(authResult.user!.uid + '.jpg');
        await ref.putFile(image!).whenComplete(() => null);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set(
          {
            'username': username,
            'email': email,
            'image_url': url
          }
        );

      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials';
      if(err.message != null){
        message = err.message as String;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).errorColor,)
       );
      setState(() {
        isLoading = false;
      });
    } catch (err){
      FirebaseException ex = err as FirebaseException;

      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(ex.message as String),
            backgroundColor: Theme.of(ctx).errorColor,)
      );
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, isLoading),
    );
  }
}
