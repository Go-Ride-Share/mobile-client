import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/profile.dart';
import 'package:crypto/crypto.dart';

class AuthService {
// For AccountManager:
static final String _accountManagerUrl = "https://grs-accountmanager.azurewebsites.net";
static final String _accountManagerDevUrl = "https://grs-accountmanager-dev.azurewebsites.net";

// For Logic:
static final String _logicApiUrl = "https://grs-logic.azurewebsites.net";
static final String _logicApiDevUrl = "https://grs-logic-dev.azurewebsites.net";

// For DbAccessor:
static final String _dbUrl = "https://grs-dbaccessor.azurewebsites.net";
static final String _dbDevUrl = "https://grs-dbaccessor-dev.azurewebsites.net";

static Map<String, String> _defaultHeaders = {
  'Content-Type': 'application/json'
};

static const Map<String, String> RESPONSE_MSG = {
  "SUCCESS": 'Sign in successful!',
  'INVALID_INPUT': 'Invalid email or password',
  'SERVER_ERROR': 'Error 500: Server error. Please try again later.',
  'UNKNOWN_ERROR': 'Unknown error',
};

/*
  This method sends a POST request to the account manager to verify the login credentials.
  Parameters:
    email: The email address of the user
    password: The password of the user
  Returns:
    A Future<String> that resolves to a message indicating the result of the sign in attempt
*/
  static Future<String> signIn(String email, String password) async {
    try {
      // SHA-256 the password
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      // Send the email and hashed password to the account manager URL
      var url = Uri.parse('$_accountManagerDevUrl/api/VerifyLoginCredentials');

      var response = await _post(url, _defaultHeaders, {'email': email, 'password': hashedPassword});

      // Handle the response
      if (response.statusCode == 200) {
        // Cache the token (assuming the token is in the response body)
        var userId = jsonDecode(response.body)['user_id'];
        var bearerToken = jsonDecode(response.body)['logic_token'];
        var dbToken = jsonDecode(response.body)['db_token'];

        //for now, print them all to console 
        print('User ID: $userId');
        print('Bearer Token: $bearerToken');
        print('DB Token: $dbToken');

        // Cache the token using your preferred method
        // For example, using shared_preferences:
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('auth_token', token);
        return RESPONSE_MSG['SUCCESS']!;
      } else if (response.statusCode == 400) {
        return RESPONSE_MSG['INVALID_INPUT']!;
      } else if (response.statusCode == 500) {
        return RESPONSE_MSG['SERVER_ERROR']!;
      } else {
        return 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error during sign in: $e');
      //return the unknown error with e as the message
      return '${RESPONSE_MSG['UNKNOWN_ERROR']!}: $e';
    }
  }

  // Future<http.Response> createAccount(Profile person) {
  // return http.post(
  //   Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode(<String, String>{
  //     'title': title,
  //   }),
  // );

    // make private http get helper method
  static Future<http.Response> _get(Uri url, Map<String, String> headers, [Map<String, String>? queryParams]) {
    if (queryParams != null && queryParams.isNotEmpty) {
      url = Uri.parse('${url.toString()}?${Uri(queryParameters: queryParams).query}');
    }
    return http.get(
      url,
      headers: headers,
    );
  }
   
  // make private http post helper method
  static Future<http.Response> _post(Uri url, Map<String, String> headers, Map<String, dynamic> body) {
    return http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
