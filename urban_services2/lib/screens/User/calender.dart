import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/servies_controller.dart';
import '../../model/provider_model.dart';

class CalendarView extends StatefulWidget {
  final ServiceProviderModel serviceProvider;
  CalendarView({required this.serviceProvider});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final serviceController = Get.put(ServiceController());
  List<String> bookedDates = [];
  bool isLoading = false;

  Future<void> fetchBookedDates() async {
    setState(() {
      isLoading = true;
    });
    List<String> fetchedDates = await serviceController.getAllBookingOfCurrentProvider(widget.serviceProvider.uid ?? "");
    setState(() {
      bookedDates = fetchedDates;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBookedDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Provider Calendar')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: EventCalendar(
          bookedDates: bookedDates,
        ),
      ),
    );
  }
}

class EventCalendar extends StatefulWidget {
  final List<String> bookedDates;

  const EventCalendar({Key? key, required this.bookedDates}) : super(key: key);

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  late final Map<DateTime, List<dynamic>> eventsMap;

  @override
  void initState() {
    super.initState();
    eventsMap = {};
    log(widget.bookedDates.toString());

    // Populate events map
    for (String dateStr in widget.bookedDates) {
      DateTime date = DateTime.parse(dateStr);
      DateTime eventDate = DateTime.utc(date.year, date.month, date.day);
      eventsMap[eventDate] = ['Booked'];
    }
  }

  // Function to fetch events for a specific day
  List<dynamic> getEventsForDay(DateTime day) {
    return eventsMap[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      eventLoader: getEventsForDay,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 5,
              bottom: 1,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.green, // Updated color for booked events
                ),
              ),
            );
          }
          return null;
        },
      ),
      calendarStyle: const CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.rectangle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false, // Hide days outside of current month
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
