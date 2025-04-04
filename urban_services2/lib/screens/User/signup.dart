import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import '../../controllers/signin_controller.dart';
import '../../controllers/user_controller.dart';
import '../../model/user_model.dart';
import '../widgets/flutterButton.dart';
import '../widgets/textFieldCustomize.dart';

import 'login.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  final ImagePicker _picker = ImagePicker();
  XFile? _profilePic;
  String _passWord = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundImage: _profilePic != null
                      ? FileImage(File(_profilePic!.path))
                      : null,
                  child: _profilePic == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 50.sp,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20.h),
              TextFieldWidget(
                label: 'Name',
                onSaved: (value) => _user.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _user.email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Phone',
                keyboardType: TextInputType.phone,
                onSaved: (value) => _user.phone = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Password',
                isPassword: true,
                onSaved: (value) => _passWord = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Address',
                onSaved: (value) => _user.address = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              DropdownButtonFormField<String>(
                // decoration: InputDecoration(labelText: 'Preferred Contact Method'),
                decoration: InputDecoration(
                  labelText: 'Preferred Contact Method',
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(
                      0.5), // You can adjust the shade of blue here
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Email', 'Phone'].map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _user.contactMethod = value;
                  });
                },
                onSaved: (value) => _user.contactMethod = value,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _submitForm,
                child: CustomizeUIButton(text: "Create Account"),
              ),
              SizedBox(
                height: 20.h,
              ),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: () {
                        Get.off(() => LoginScreen());
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.black),
                      ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePic = image;
      });
    }
  }

  final controller = Get.put(SigningController());
  final controllerUser = Get.put(UserController());
  bool _loading = false;
  void _submitForm() async {
    if (_profilePic == null) {
      Get.snackbar("Error", "Please select a profile picture",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      _formKey.currentState!.save();
      // Handle form submission here
      print(userModelToJson(_user));
      String url = await controllerUser
          .uploadFileToCloud(await _profilePic!.readAsBytes());
      _user.profilePic = url;
      var uid = await controller.register(
          email: _user.email ?? "",
          password: _passWord ?? "",
          user: _user,
          userType: 'user',
          context: context);
      setState(() {
        _loading = false;
      });
    }
  }
}
