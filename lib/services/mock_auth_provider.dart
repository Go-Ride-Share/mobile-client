import 'dart:async';

class MockAuthProvider {
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 3));

    // Mock response
    if (email == 'test@example.com' && password == 'password') {
      return {
        'status': 200,
        'message': 'Sign in successful',
        'data': {
          "logic_token": "oauth-token-generated-by-microsoft-for-logic-access",
          "db_token": "oauth-token-generated-by-microsoft-for-db-access"
        },
      };
    } else {
      return {
        'status': 401,
        'message': 'Invalid email or password',
      };
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Mock response
    return {
      'status': 201,
      'message': 'Sign up successful',
      'data': {
          "logic_token": "oauth-token-generated-by-microsoft-for-logic-access",
          "db_token": "oauth-token-generated-by-microsoft-for-db-access"
      },
    };
  }
}