import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  String _userEmail = '';
  String _userUsername = '';
  String _userPassword = '';
  File _userImageFile;
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin) {
      if (_userImageFile == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Please pick an image.'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userUsername.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  void _pickImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    key: ValueKey('Email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Username must be 8 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userUsername = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('Passsword'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Password must be 8 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    obscureText: true, // giau password
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        _isLogin
                            ? 'Create New Account'
                            : 'I already have an account',
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
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
