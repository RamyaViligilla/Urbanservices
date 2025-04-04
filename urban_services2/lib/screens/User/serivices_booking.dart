import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:urban_services/model/booked_serivece_model_user.dart';
import 'package:urban_services/screens/User/review_screen.dart';
import '../../controllers/servies_controller.dart';
import '../../controllers/signin_controller.dart';
import '../../controllers/user_controller.dart';
import '../../model/booked_service_model_provider.dart';
import '../../model/provider_model.dart';
import '../../model/service_package_model.dart';
import 'calender.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ServiceProviderModel serviceProvider;

  ServiceDetailsScreen({required this.serviceProvider});

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  double _rating = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime; // Add time selection
  final TextEditingController _reviewController = TextEditingController();
  String? _selectedPackage;
  List<String> _servicePackages = [
    "1 hour £ 500",
    "2 hour £ 1000",
    "3 hour £ 1500",
    "4 hour £ 2000",
  ];
  List<DateTime> _disabledDates = [];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  final controller = Get.put(SigningController());
  final userController = Get.put(UserController());
  final providerController = Get.put(ServiceController());
  bool _loading = false;

  void _bookService() async {
    if (_selectedPackage == null || _selectedDate == null || _selectedTime == null) {
      Get.snackbar("Error", "Please choose package, date, and time correctly",
          backgroundColor: Colors.red);
      return;
    }
    setState(() {
      _loading = true;
    });

    // Combine date and time
    final bookingDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final DateTime rangeStart = bookingDateTime.subtract(Duration(minutes: 30));
    final DateTime rangeEnd = bookingDateTime.add(Duration(minutes: 30));


    for (DateTime disabledDate in _disabledDates) {
      if (disabledDate.isAfter(rangeStart) && disabledDate.isBefore(rangeEnd)) {
        Get.snackbar("Occupied", "Service provider is already booked within 30 minutes of the selected time");
        setState(() {
          _loading = false;
        });
        return;
      }
    }
    BookedServiceProvider serviceProviderModelProvider =
    BookedServiceProvider.fromJson(userController.currentUser.toJson());
    serviceProviderModelProvider.servicePackage = _selectedPackage ?? "";
    serviceProviderModelProvider.date = bookingDateTime.toString(); // Use combined date and time

    BookedServiceUser bookedServiceUser =
    BookedServiceUser.fromJson(widget.serviceProvider.toJson());
    bookedServiceUser.servicePackage = _selectedPackage ?? "";
    bookedServiceUser.date = bookingDateTime.toString(); // Use combined date and time

    bool res = await providerController.bookService(
        bookedServiceUser, serviceProviderModelProvider);
    if (res) {
      setState(() {
        _loading = false;
      });
      Get.back();
    }

    print(
        'Service Booked: ${widget.serviceProvider} on $bookingDateTime with package $_selectedPackage');
  }

  bool _geting = false;

  getPackage() async {
    List<DateTime> lsd = [];

    setState(() {
      _geting = true;
    });
    List<String> pkg = await providerController
        .getServicePackages(widget.serviceProvider.uid ?? "");
    List<String> ls = await cntrl
        .getAllBookingOfCurrentProvider(widget.serviceProvider.uid ?? "");
    for (var i in ls) {
      lsd.add(DateTime.parse(i));
    }
    log("message" + ls.toString());
    log("message" + lsd.toString());
    setState(() {
      _disabledDates = lsd;
      log("ghgh" + _disabledDates.toString());
      if (pkg.isNotEmpty) {
        _servicePackages = pkg;
      }
      _geting = false;
    });
  }

  final cntrl = Get.put(ServiceController());

  @override
  void initState() {
    getPackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceProvider.serivceCategory ?? ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _geting
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Book and Schedule Service',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                const Text(
                  'Select Service Package',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  hint: Text('Select Package'),
                  value: _selectedPackage,
                  items: _servicePackages.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPackage = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => CalendarView(
                      serviceProvider: widget.serviceProvider,
                    ));
                  },
                  child: Text('See Providers Booked Dates'),
                ),
                SizedBox(height: 10),
                const Text(
                  'Select Booking Date',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _selectedDate != null
                    ? Text('Selected Date: ${_selectedDate!.toLocal()}')
                    : Text('No date selected'),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
                SizedBox(height: 20),
                const Text(
                  'Select Booking Time',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _selectedTime != null
                    ? Text('Selected Time: ${_selectedTime!.format(context)}')
                    : Text('No time selected'),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Select Time'),
                ),
                SizedBox(height: 20),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _bookService,
                  child: Text('Book Service'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
