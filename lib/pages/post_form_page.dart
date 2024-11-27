import 'package:flutter/material.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/theme.dart';
import 'package:go_ride_sharing/widgets/map_window.dart';
import 'package:go_ride_sharing/pages/map_page.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;

  const PostFormPage({super.key, this.post});

  @override
  _PostFormPageState createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _postNameController = TextEditingController();
  final _postDescriptionController = TextEditingController();
  final _seatsAvailableController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _priceController = TextEditingController();
  final _originLngController = TextEditingController();
  final _originLatController = TextEditingController();
  final _destinationLngController = TextEditingController();
  final _destinationLatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If a post is passed, populate the form fields with its data
    if (widget.post != null) {
      _postNameController.text = widget.post!.postName;
      _postDescriptionController.text = widget.post!.description;
      _seatsAvailableController.text = widget.post!.seatsAvailable.toString();
      _departureDateController.text =
          widget.post!.departureDate.toLocal().toString().split(' ')[0];
      _priceController.text = widget.post!.price.toString();
      _originLngController.text = widget.post!.originLng.toString();
      _originLatController.text = widget.post!.originLat.toString();
      _destinationLngController.text =
          widget.post!.destinationLng.toString();
      _destinationLatController.text =
          widget.post!.destinationLat.toString();
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _postNameController.dispose();
    _postDescriptionController.dispose();
    _seatsAvailableController.dispose();
    _departureDateController.dispose();
    _priceController.dispose();
    _originLngController.dispose();
    _originLatController.dispose();
    _destinationLngController.dispose();
    _destinationLatController.dispose();
    super.dispose();
  }

  // Function to select a date using a date picker
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

  // Function to submit the post form
  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        originLat: double.parse(_originLatController.text),
        originLng: double.parse(_originLngController.text),
        destinationLat: double.parse(_destinationLatController.text),
        destinationLng:
            double.parse(_destinationLngController.text),
        description: _postDescriptionController.text,
        seatsAvailable: int.parse(_seatsAvailableController.text),
        postName: _postNameController.text,
        departureDate: DateTime.parse(_departureDateController.text),
        price: double.parse(_priceController.text),
      );

      // TODO: POTENTIALLY USELESS CODE, might need to rethink how Post Update works
      // Create or update the post based on whether a post was passed
      if (widget.post == null) {
        await PostService().createPost(post);
      } else {
        await PostService().updatePost(post);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.post == null ? 'Create a Post' : 'Update Post';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
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
              CustomTextFormField(
                controller: _priceController,
                labelText: 'Price',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
              Stack(
                alignment: Alignment.center,
                children: [
                  MapWindow(),  //TODO: param are the coordinates
                  Positioned(
                    top: 20,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        backgroundColor: notYellow,
                        foregroundColor: notBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: notBlack,
                        elevation:
                            10, // Increase elevation for a more prominent shadow
                      ),
                      icon: const Icon(Icons.pin_drop),
                      label: const Text("Choose Locations"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: FilledButton.styleFrom(
                    backgroundColor: notYellow,
                    foregroundColor: notBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: notBlack),
                onPressed: _submitPost,
                child: Text(widget.post == null ? 'Post' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
