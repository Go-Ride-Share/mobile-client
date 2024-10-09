import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/validation_service.dart';
import '../services/auth_service.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key}); // Add const constructor

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Add error handling for sign up
  bool _error = false;
  String _errorMessage = '';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => ValidationService.validateEmail(value),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => ValidationService.validatePassword(value),

              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 2,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => ValidationService.validatePhoneNumber(value),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(File(_image!.path)),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload profile picture'),
              ),
              if (_error)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  // bundle up all the data in a Map<String, dynamic>
                  final Map<String, dynamic> formData = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'bio': _bioController.text,
                    'phone': _phoneController.text,
                    'image': _image,
                  };
                  final String response = await AuthService.signUp(formData);
                  if (response == AuthService.RESPONSE_MSG["SUCCESS"]) {
                    Navigator.pushNamed(context, '/home');
                  } else {
                    if (mounted) {
                        setState(() {
                          _error = true;
                          _errorMessage = response;
                        });
                    }
                  }
                }
              },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}