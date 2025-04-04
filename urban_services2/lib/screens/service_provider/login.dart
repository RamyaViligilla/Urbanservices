import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urban_services/screens/service_provider/signup.dart';
import '../../controllers/signin_controller.dart';
import '../../controllers/user_controller.dart';
import '../User/home_screen.dart';
import '../../model/user_model.dart';
import '../User/signup.dart';
import '../widgets/flutterButton.dart';
import '../widgets/textFieldCustomize.dart';
import 'bottombar_provider.dart';
import 'home_provider.dart';

class LoginScreenServiceProvider extends StatefulWidget {
  @override
  _LoginScreenServiceProviderState createState() =>
      _LoginScreenServiceProviderState();
}

class _LoginScreenServiceProviderState
    extends State<LoginScreenServiceProvider> {
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Service Provider Login',
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w500,
          ),
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
                _loading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : InkWell(
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
                      Get.off(() => SignupScreenServiceProvider());
                    },
                    child: Text(
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
      setState(() {
        _loading = true;
      });
      _formKey.currentState!.save();

      // Attempt login
      var res = await controller.login(
        email: _email ?? "",
        password: _password ?? "",
        userType: 'provider',
        context: context,
      );

      setState(() {
        _loading = false;
      });

      if (res) {
        var isProvider = await checkIfServiceProvider(_email);
        if (isProvider) {
          Get.to(() => BottombarProvider());
        } else {
          // Show a toast if the entered details are for a user, not a provider
          Fluttertoast.showToast(
              msg: "Entered details belong to a regular user. Please log in as a user.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  Future<bool> checkIfServiceProvider(String email) async {
    // Check if the email exists in the service provider collection
    var providerDoc = await FirebaseFirestore.instance

        .collection('Provider')
        .where('email', isEqualTo: email)
        .get();

    return providerDoc.docs.isNotEmpty;
  }
}
