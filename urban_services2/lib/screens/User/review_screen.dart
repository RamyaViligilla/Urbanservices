import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:urban_services/controllers/servies_controller.dart';
import 'package:urban_services/model/review_model.dart';

class ReviewScreen extends StatefulWidget {
  String uid;
  ReviewScreen({super.key, required this.uid});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 0;
  DateTime? _selectedDate;
  final TextEditingController _reviewController = TextEditingController();
  final controller = Get.put(ServiceController());
  bool _loading = false;
  void _submitReview() async {
    setState(() {
      _loading = true;
    });
    ReviewModel model = ReviewModel();
    model.rating = _rating.toString();
    model.review = _reviewController.text;
    await controller.sendRating(widget.uid, model);
    log('Review Submitted: ${_reviewController.text}, Rating: $_rating');
    Get.back();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.red,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Write a review',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Submit Review'),
                  ),
          ],
        ),
      ),
    );
  }
}
