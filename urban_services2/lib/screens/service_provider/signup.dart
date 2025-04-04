import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/signin_controller.dart';
import '../../controllers/proider_controller.dart';
import '../User/home_screen.dart';
import '../../model/provider_model.dart';
import 'dart:io';
import '../widgets/flutterButton.dart';
import '../widgets/textFieldCustomize.dart';
import 'bottombar_provider.dart';

class SignupScreenServiceProvider extends StatefulWidget {
  @override
  _SignupScreenServiceProviderState createState() =>
      _SignupScreenServiceProviderState();
}

final _sitter = ServiceProviderModel();

class _SignupScreenServiceProviderState
    extends State<SignupScreenServiceProvider> {
  final _formKey = GlobalKey<FormState>();

  // Declare TextEditingControllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _businessAddressController = TextEditingController();
  final TextEditingController _serviceCategoryController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();
  final TextEditingController _serviceAreaController = TextEditingController();
  final TextEditingController _availabilityScheduleController = TextEditingController();
  final TextEditingController _paymentInfoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _profilePic;
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePic = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
  }

  @override
  void dispose() {
    // Dispose the controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _businessAddressController.dispose();
    _serviceCategoryController.dispose();
    _qualificationController.dispose();
    _serviceDescriptionController.dispose();
    _serviceAreaController.dispose();
    _availabilityScheduleController.dispose();
    _paymentInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Provider Registration',
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.h,
              ),
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
                controller: _nameController,
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
                controller: _emailController,
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
                controller: _phoneController,
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
                controller: _passwordController,
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
                label: 'Business Address',
                controller: _businessAddressController,
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
                  labelText: 'Service Category',
                  filled: true,
                  fillColor: Colors
                      .blueAccent.withOpacity(0.5), // You can adjust the shade of blue here
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Cleaning', 'Repairs',"Beauty",
                "Plumbing", 'Electrical','Landscaping','Security',
                  'Medical'
                ].map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _serviceCategoryController.text = value ?? "Cleaning";
                  });
                },
                onSaved: (value) =>   _serviceCategoryController.text = value ?? "Cleaning",
              ),
              // TextFieldWidget(
              //   label: 'Service Category',
              //   controller: _serviceCategoryController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your service category';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Qualification',
                controller: _qualificationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your qualification';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Service Description',
                controller: _serviceDescriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your service description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Service Area',
                controller: _serviceAreaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your service area';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Availability Schedule',
                controller: _availabilityScheduleController,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your availability schedule';
                //   }
                //   return null;
                // },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldWidget(
                label: 'Payment Information',
                controller: _paymentInfoController,
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(height: 20),
            _loading ?  Center(child: CircularProgressIndicator(),) :   InkWell(
                onTap: _submitForm,
                child: CustomizeUIButton(text: "Create Account"),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextButton(
                  onPressed: () {
                    // Get.off(() => LoginScreen());
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

  final controller = Get.put(SigningController());
  final controllerUser = Get.put(ProviderController());
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
      // Store data in _sitter model
      _sitter.name = _nameController.text;
      _sitter.email = _emailController.text;
      _sitter.phone = _phoneController.text;
      _sitter.password = _passwordController.text;
      _sitter.businessAddress = _businessAddressController.text;
      _sitter.serivceCategory = _serviceCategoryController.text;
      _sitter.qualification = _qualificationController.text;
      _sitter.serviceDescription = _serviceDescriptionController.text;
      _sitter.serviceArea = _serviceAreaController.text;
      _sitter.availibilitySchedule = _availabilityScheduleController.text;
      _sitter.paymentInfo = _paymentInfoController.text;
      log(_sitter.toString());
      String url = await controllerUser
          .uploadFileToCloud(await _profilePic!.readAsBytes());
      _sitter.profilePic = url;
      var uid = await controller.register(
          email: _sitter.email ?? "",
          password: _sitter.password ?? "",
          userType: 'provider', provider: _sitter, context: context);
      _sitter.uid = uid;
      setState(() {
        _loading = false;
      });
      if (!uid) {
        await controllerUser.sendProviderToCloud(_sitter);
        Get.to(() => BottombarProvider());
        // You can now send the sitter data to the backend or perform other actions
      }
    }
  }
}
