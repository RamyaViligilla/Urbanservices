import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/signin_controller.dart';
import 'package:urban_services/controllers/user_controller.dart';
import 'package:urban_services/screens/User/all_bookings.dart';
import 'package:urban_services/screens/User/provider_list.dart';
import '../../controllers/servies_controller.dart';
import 'all_completed_bookings.dart';
import 'location_search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.cleaning_services,
      'label': 'Cleaning',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Cleaning',)),
        );
      },
    },
    {
      'icon': Icons.build,
      'label': 'Repairs',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Repairs',)),
        );
      },
    },
    {
      'icon': Icons.spa,
      'label': 'Beauty',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Beauty',)),
        );
      },
    },
    {
      'icon': Icons.plumbing,
      'label': 'Plumbing',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Plumbing',)),
        );
      },
    },
    {
      'icon': Icons.electric_bolt,
      'label': 'Electrical',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Electrical',)),
        );
      },
    },
    {
      'icon': Icons.landscape,
      'label': 'Landscaping',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Landscaping',)),
        );
      },
    },
    {
      'icon': Icons.security,
      'label': 'Security',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Security',)),
        );
      },
    },
    {
      'icon': Icons.delivery_dining,
      'label': 'Delivery',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Delivery',)),
        );
      },
    },
    {
      'icon': Icons.medical_services,
      'label': 'Medical',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderList(category: 'Medical',)),
        );
      },
    },
  ];
  bool _loading = false;
getData()async{
  setState(() {
    _loading = true;
  });
  if(!FirebaseAuth.instance.currentUser!.emailVerified){
    await controller.signOutUser();
  }
  await providerController.getAllProviders();
  await userController.getCurrentLoggedInUser();
  setState(() {
    _loading = false;
  });
}
  @override
  void initState() {
    super.initState();
    getData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
final controller = Get.put(SigningController());
final userController = Get.put(UserController());
final providerController = Get.put(ServiceController());
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredServices = _services.where((service) {
      return service['label'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                color: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userController.currentUser.value.profilePic ??""),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome, ${userController.currentUser.value.name ??""}!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${userController.currentUser.value.email ??""}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.book_online, color: Colors.teal),
                title: Text(
                  "Your Bookings",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Get.to(() => AllBookings());
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.teal),
                title: Text(
                  "Completed Bookings",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Get.to(() => AllCompleteBookings());
                },
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    await controller.signOutUser();
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        )
,
          appBar: AppBar(
          title: Text('Services'),
          actions: [
          ],
        ),
        body: _loading ?  const Center(child: CircularProgressIndicator(),) :  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Home Services',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
              onTap: (){
                Get.to(()=>const ProvidersByLocation());
              },
                child: const Text(
                  'Search Service Providers by location',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: filteredServices.map((service) {
                    return ServiceCard(
                      icon: service['icon'],
                      label: service['label'],
                      onTap: () => service['onTap'](context),
                    );
                  }).toList(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ServiceCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
