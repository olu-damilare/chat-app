import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String password, String username, File? image,  bool isLogin, BuildContext ctx) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;
  File? _userImageFile;

  void _trySubmit(){
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(!_isLogin && _userImageFile == null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please pick an image'),
            backgroundColor: Theme.of(context).errorColor,
          ),
      );
      return;
    }

    if(isValid){
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
          _userImageFile,
          _isLogin,
        context
      );
    }
  }

  void _pickedImage(File file){
    _userImageFile = file;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!_isLogin)
                    UserImagePicker(imagePickFn: _pickedImage ),

                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    onSaved: (value) {
                       _userEmail = value!;
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !value.contains('@')){
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  if(!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      autocorrect: true,
                      onSaved: (value) {
                        _userName = value!;
                      },
                    validator: (value){
                      if(value == null || value.isEmpty || value.length < 4){
                        return 'Username must be at least 4 characters long';
                      }
                      return null;
                    },
                     decoration: InputDecoration(
                      labelText: 'Username'
                    ),
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (value) {
                        _userPassword = value!;
                      },
                    validator: (value){
                      if(value == null || value.isEmpty || value.length < 7){
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password'
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12,),

                  if(widget.isLoading)
                    CircularProgressIndicator(),

                  if(!widget.isLoading)
                  ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign up')
                  ),

                  if(!widget.isLoading)
                  TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            color: Theme.of(context).primaryColor
                          )
                      )
                    ),
                      onPressed: (){
                      setState((){
                        _isLogin = !_isLogin;

                      });
                      },
                      child: Text(_isLogin ? 'Create new account.' : 'Already have an account? Login')
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
