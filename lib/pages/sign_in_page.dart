import 'package:flutter/material.dart';
import '../pages/sign_up_page.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_provider.dart';
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
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => ValidationService.validateEmail(value),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => ValidationService.validatePassword(value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  final authenticator = MockAuthProvider();
                  final token = await authenticator.signIn(email, password);
                  if (token != null) { //DO A BETTER CHECK HERE
                    Navigator.pushNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid email or password')),
                    );
                  }
                }
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
                },
              child: Text('Click here to create an account'),
            )
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
