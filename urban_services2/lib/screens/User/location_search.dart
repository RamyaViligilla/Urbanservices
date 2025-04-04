import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/servies_controller.dart';
import 'package:urban_services/controllers/signin_controller.dart';
import 'package:urban_services/screens/admin/provider_deatils.dart';

import '../../model/provider_model.dart';
import 'deatil.dart';

class ProvidersByLocation extends StatefulWidget {
  const ProvidersByLocation({super.key});

  @override
  State<ProvidersByLocation> createState() => _ProvidersByLocationState();
}

class _ProvidersByLocationState extends State<ProvidersByLocation> {
  List<ServiceProviderModel> allProviders = [];
  List<ServiceProviderModel> filteredProviders = [];
  final controller = Get.put(ServiceController());
  final cont = Get.put(SigningController());
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;

  get() async {
    setState(() {
      _loading = true;
    });
    await controller.getAllProviders();
    setState(() {
      filteredProviders = controller.allProvider;
      _loading = false;
    });
  }

  @override
  void initState() {
    get();
    _searchController.addListener(_filterProviders);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProviders() {
    setState(() {
      filteredProviders = controller.allProvider.where((provider) {
        final searchText = _searchController.text.toLowerCase();
        return provider.serviceArea?.toLowerCase().contains(searchText) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search Provider"),
      
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by location',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: filteredProviders.length,
          itemBuilder: (context, index) {
            return ListTile(
                onTap: () {
                  Get.to(() => ServiceProviderDetailsScreen(
                    serviceProvider: filteredProviders[index],
                  ));
                },
                title: Text(filteredProviders[index].name ?? ""),
                subtitle: Text(filteredProviders[index].email ?? ""),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      filteredProviders[index].profilePic ?? ""),
                ),
                trailing: filteredProviders[index].verified ?? false
                    ? const Text(
                  "Verified",
                  style: TextStyle(color: Colors.green),
                )
                    : const Text(
                  "Unverified",
                  style: TextStyle(color: Colors.red),
                ),
              );

          },
        ),
      ),
    );
  }
}
