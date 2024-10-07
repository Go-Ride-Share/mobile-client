import 'package:flutter/material.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:go_ride_sharing/services/post_service.dart';

/// Main page for creating a post
class CreatePostPage extends StatefulWidget {
  final Post? post;

  const CreatePostPage({super.key, this.post});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // Form key to identify the form and validate it
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final _postNameController = TextEditingController();
  final _postDescriptionController = TextEditingController();
  final _seatsAvailableController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _priceController = TextEditingController();
  final _startLongitudeController = TextEditingController();
  final _startLatitudeController = TextEditingController();
  final _destinationLongitudeController = TextEditingController();
  final _destinationLatitudeController = TextEditingController();

  // Dispose controllers to free up resources when the widget is removed from the widget tree
  @override
  void dispose() {
    _postNameController.dispose();
    _postDescriptionController.dispose();
    _seatsAvailableController.dispose();
    _departureDateController.dispose();
    _priceController.dispose();
    _startLongitudeController.dispose();
    _startLatitudeController.dispose();
    _destinationLongitudeController.dispose();
    _destinationLatitudeController.dispose();
    super.dispose();
  }

  // Function to show date picker and set the selected date to the controller
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _departureDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  // Function to create a Post object and call the PostService
  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        authToken: 'your_auth_token', // Replace with actual auth token
        startLatitude: double.parse(_startLatitudeController.text),
        startLongitude: double.parse(_startLongitudeController.text),
        destinationLatitude: double.parse(_destinationLatitudeController.text),
        destinationLongitude: double.parse(_destinationLongitudeController.text),
        description: _postDescriptionController.text,
        seatsAvailable: int.parse(_seatsAvailableController.text),
        postName: _postNameController.text,
        posterName: 'your_poster_name', // Replace with actual poster name
        departureDate: DateTime.parse(_departureDateController.text),
        price: double.parse(_priceController.text),
      );

      await PostService().createPost(post);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          // Close button to navigate back to the previous screen
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Custom widget for Post Name field
              CustomTextFormField(
                controller: _postNameController,
                labelText: 'Post Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a post name';
                  }
                  return null;
                },
              ),
              // Custom widget for Post Description field
              CustomTextFormField(
                controller: _postDescriptionController,
                labelText: 'Post Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a post description';
                  }
                  return null;
                },
              ),
              // Custom widget for Seats Available field
              CustomTextFormField(
                controller: _seatsAvailableController,
                labelText: 'Seats Available',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of seats available';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Custom widget for Departure Date field
              CustomTextFormField(
                controller: _departureDateController,
                labelText: 'Departure Date',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a departure date';
                  }
                  return null;
                },
              ),
              // Custom widget for Price field
              CustomTextFormField(
                controller: _priceController,
                labelText: 'Price',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid decimal number';
                  }
                  return null;
                },
              ),
              // Custom widget for Start Longitude field
              CustomTextFormField(
                controller: _startLongitudeController,
                labelText: 'Start Longitude',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start longitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid decimal number';
                  }
                  return null;
                },
              ),
              // Custom widget for Start Latitude field
              CustomTextFormField(
                controller: _startLatitudeController,
                labelText: 'Start Latitude',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start latitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid decimal number';
                  }
                  return null;
                },
              ),
              // Custom widget for Destination Longitude field
              CustomTextFormField(
                controller: _destinationLongitudeController,
                labelText: 'Destination Longitude',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the destination longitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid decimal number';
                  }
                  return null;
                },
              ),
              // Custom widget for Destination Latitude field
              CustomTextFormField(
                controller: _destinationLatitudeController,
                labelText: 'Destination Latitude',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the destination latitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid decimal number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Button to submit the form
              ElevatedButton(
                onPressed: _createPost,
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom reusable TextFormField widget
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.readOnly = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
    );
  }
}
