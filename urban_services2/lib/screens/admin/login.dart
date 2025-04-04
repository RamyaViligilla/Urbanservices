import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../model/user_model.dart';
import '../widgets/flutterButton.dart';
import '../widgets/textFieldCustomize.dart';
import 'admin_home.dart';

class LoginScreenAdmin extends StatefulWidget {
  @override
  _LoginScreenAdminState createState() => _LoginScreenAdminState();
}

class _LoginScreenAdminState extends State<LoginScreenAdmin> {
  final controller = Get.put(AdminController());
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  String _email = "";
  String _password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Account Admin',
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
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
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: ()async{
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _loading = true;
                            });
                            log(userModelToJson(_user));
                            var res = await controller.adminLoginFirebase(
                                email: _email ?? "",
                                password: _password ?? "",
                                userType: 'admin',
                                context: context);
                            setState(() {
                              _loading = true;
                            });
                            if (res) {
                              Get.off(() => const AdminHome());
                            }
                          }
                        },
                        child: CustomizeUIButton(
                          text: "login",
                          width: 1.sw,
                        ),
                      ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _loading = false;

}
