import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/servies_controller.dart';
import 'package:urban_services/controllers/signin_controller.dart';
import 'package:urban_services/model/provider_model.dart';
import '../../controllers/proider_controller.dart';

class ProfileScreenProvider extends StatefulWidget {
  @override
  State<ProfileScreenProvider> createState() => _ProfileScreenProviderState();
}

class _ProfileScreenProviderState extends State<ProfileScreenProvider> {
  final userController = Get.put(ProviderController());
  final serviceController = Get.put(ServiceController());
  final signinController = Get.put(SigningController());
double ratings = 0.0;
bool _fetching = false;
getData()async{
  setState(() {
    _fetching = true;
  });
  await userController.gettingLoggedInUser();
  await serviceController.getAllTheRatingsOfProvider(FirebaseAuth.instance.currentUser?.uid ?? "");
  setState(() {
    ratings = serviceController.calculateRatin();
    _fetching = false;
  });
}
  @override
  void initState() {
    super.initState();
getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _fetching ?   Center(child: CircularProgressIndicator(),)  :  Obx(
            () {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (userController.loggedInUser.value == null) {
            return const Center(child: Text('No user data found.'));
          } else {
            final ServiceProviderModel userModel = userController.loggedInUser.value!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(userModel),
                  const SizedBox(height: 10),
                  Expanded(child: _buildProfileDetails(userModel)),
                  const SizedBox(height: 10),
                  _buildLogOutButton(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(ServiceProviderModel userModel) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(userModel.profilePic ?? ""),
            backgroundColor: Colors.orange.withOpacity(0.2),
          ),
          const SizedBox(height: 10),
          Text(
            userModel.name ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userModel.serivceCategory ?? '',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star,color: Colors.amber,),
              Text(
                ratings.toString().substring(0,3),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(ServiceProviderModel userModel) {
    return ListView(
      children: [
        _buildInfoCard('Email', userModel.email ?? '', Icons.email),
        _buildInfoCard('Phone', userModel.phone ?? '', Icons.phone),
        _buildInfoCard('Business Address', userModel.businessAddress ?? '', Icons.location_on),
        _buildInfoCard('Service Description', userModel.serviceDescription ?? '', Icons.description),
        _buildInfoCard('Service Area', userModel.serviceArea ?? '', Icons.map),
        _buildInfoCard('Qualification', userModel.qualification ?? '', Icons.school),
        _buildInfoCard('Availability Schedule', userModel.availibilitySchedule ?? '', Icons.schedule),
        _buildInfoCard('Payment Info', userModel.paymentInfo ?? '', Icons.payment),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[700]),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[800]),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _buildLogOutButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        await signinController.signOutUser();
      },
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Log Out'),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange[700],
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
