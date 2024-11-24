import 'package:flutter/material.dart';
import 'package:go_ride_sharing/theme.dart';
import '../services/auth_service.dart';
import '../services/validation_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key}); // Add const constructor

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Add error handling for sign in
  bool _error = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => ValidationService.validateEmail(value),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => ValidationService.validatePassword(value),
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
                  final String response = await AuthService.signIn(_emailController.text, _passwordController.text);
                  if (response == AuthService.RESPONSE_MSG["SUCCESS"]) {
                    Navigator.pushReplacementNamed(context, '/home');
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
              child: const Text('Sign In'),
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
                onPressed: () {
                Navigator.pushNamed(context, '/sign_up_page');
                },
              child: const Text('Click here to create an account'),
            ),
          ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
