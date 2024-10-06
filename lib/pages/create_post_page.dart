import 'package:flutter/material.dart';

/// Main page for creating a post
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

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

  // Dispose controllers to free up resources when the widget is removed from the widget tree
  @override
  void dispose() {
    _postNameController.dispose();
    _postDescriptionController.dispose();
    _seatsAvailableController.dispose();
    _departureDateController.dispose();
    _priceController.dispose();
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
              PostNameField(controller: _postNameController),
              // Custom widget for Post Description field
              PostDescriptionField(controller: _postDescriptionController),
              // Custom widget for Seats Available field
              SeatsAvailableField(controller: _seatsAvailableController),
              // Custom widget for Departure Date field
              DepartureDateField(
                controller: _departureDateController,
                selectDate: () => _selectDate(context),
              ),
              // Custom widget for Price field
              PriceField(controller: _priceController),
              const SizedBox(height: 20),
              // Button to submit the form
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data if the form is valid
                    Navigator.pop(context);
                  }
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TextFormField for Post Name
class PostNameField extends StatelessWidget {
  final TextEditingController controller;

  const PostNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Post Name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a post name';
        }
        return null;
      },
    );
  }
}

/// TextFormField for Post Description
class PostDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const PostDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Post Description'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a post description';
        }
        return null;
      },
    );
  }
}

/// TextFormField for Seats Available
class SeatsAvailableField extends StatelessWidget {
  final TextEditingController controller;

  const SeatsAvailableField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Seats Available'),
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
    );
  }
}

/// TextFormField for Departure Date
class DepartureDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback selectDate;

  const DepartureDateField({super.key, required this.controller, required this.selectDate});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Departure Date',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: selectDate,
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a departure date';
        }
        return null;
      },
    );
  }
}

/// TextFormField for Price
class PriceField extends StatelessWidget {
  final TextEditingController controller;

  const PriceField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Price'),
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
    );
  }
}
