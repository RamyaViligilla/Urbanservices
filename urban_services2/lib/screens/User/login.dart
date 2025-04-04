import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urban_services/screens/User/signup.dart';
import '../../controllers/signin_controller.dart';
import '../../controllers/user_controller.dart';
import 'home_screen.dart';
import '../../model/user_model.dart';
import '../widgets/flutterButton.dart';
import '../widgets/textFieldCustomize.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Account',
          style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFieldWidget(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value!,
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
                  label: 'Password',
                  isPassword: true,
                  onSaved: (value) => _password = value!,
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
                InkWell(
                  onTap: _submitForm,
                  child: CustomizeUIButton(
                    text: "login",
                    width: 1.sw,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextButton(
                    onPressed: () {
                      Get.off(() => SignupScreen());
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  final controller = Get.put(SigningController());
  final controllerUser = Get.put(UserController());
  bool _loading = false;
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });
      var res = await controller.login(
          email: _email, password: _password, userType: 'user', context: context);

      setState(() {
        _loading = false;
      });

      if (res) {
        var isProvider = await checkIfServiceProvider(_email);
        if (isProvider) {
          Fluttertoast.showToast(
              msg: "Your account is registered as service provider. Login as Service Provider",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Get.to(() => HomeScreen());
        }
      }
    }
  }

  Future<bool> checkIfServiceProvider(String email) async {
    var providerDoc = await FirebaseFirestore.instance
        .collection('Provider')
        .where('email', isEqualTo: email)
        .get();
    if (providerDoc.docs.isNotEmpty) {
      return true;
    }
    return false;
  }
}
