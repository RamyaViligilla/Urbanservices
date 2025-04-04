import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/proider_controller.dart';
import 'package:urban_services/controllers/servies_controller.dart';

import '../../model/service_package_model.dart';

class AddServicePackageForm extends StatefulWidget {
  @override
  _AddServicePackageFormState createState() => _AddServicePackageFormState();
}

class _AddServicePackageFormState extends State<AddServicePackageForm> {
  final _formKey = GlobalKey<FormState>();
  final _packageNameController = TextEditingController();
  final _servicesController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _packageNameController.dispose();
    _servicesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Service Package'),
        backgroundColor: Colors.orange[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _packageNameController,
                label: 'Package Name',
                icon: Icons.label,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the package name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _servicesController,
                label: 'Services',
                icon: Icons.build,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the services';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
    );
  }

  final helper = Get.put(ServiceController());
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() == true) {

          final package = ServicePackageModel(
            pakcageName: _packageNameController.text,
            serivices: _servicesController.text,
            price: _priceController.text,
          );

          bool isUpload = await helper.uploadServicePackages(package);
          if (isUpload) {
            Get.back();
          }
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.orange[700],
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      child: Text('Create Package'),
    );
  }
}
