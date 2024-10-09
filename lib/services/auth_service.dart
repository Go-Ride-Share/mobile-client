import 'package:http/http.dart' as http;
import 'dart:convert';
import 'caching_service.dart';
import '../constants.dart';
import 'package:crypto/crypto.dart';
class AuthService {

static final Map<String, String> _defaultHeaders = {
  'Content-Type': 'application/json'
};

static final Map<String, String> RESPONSE_MSG = {
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
      CachingService cache = CachingService();
      // SHA-256 the password
      var bytes = utf8.encode(password);
      var hashedPassword = password; //sha256.convert(bytes).toString();

      // Send the email and hashed password to the account manager URL
      var url = Uri.parse('${ENV.API_AUTH_URL}/api/VerifyLoginCredentials');
      var response = await _post(url, _defaultHeaders, {'email': email, 'password': hashedPassword});

      // Handle the response
      if (response.statusCode == 200) {
        // Cache the token (assuming the token is in the response body)
        var userId = jsonDecode(response.body)['user_id'];
        var bearerToken = jsonDecode(response.body)['logic_token'];

        // Cache the token with 1 day expiration
        await cache.saveData(ENV.CACHE_USER_ID_KEY, userId, const Duration(days: ENV.TOKEN_EXPIRATION_DURATION));
        await cache.saveData(ENV.CACHE_TOKEN_KEY, bearerToken, const Duration(hours: ENV.TOKEN_EXPIRATION_DURATION));
        await cache.saveData(ENV.PROFILE_NAME, "John", const Duration(hours: ENV.TOKEN_EXPIRATION_DURATION));

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

  static Future<String> sign_up(Map<String, dynamic> formData) async {
    try {
      // Extract email and password from formData
      String password = formData['password'];

      CachingService cache = CachingService();
      // SHA-256 the password
      var bytes = utf8.encode(password);
      formData['password'] = sha256.convert(bytes).toString();;
      // Send the email and hashed password to the account manager URL
      var url = Uri.parse('${ENV.API_AUTH_URL}/api/CreateUser');
      var response = await _post(url, _defaultHeaders, formData);

      // Print all the response data
      print('Asit Response data: ${response.body}');

      // Handle the response
      if (response.statusCode == 200) {
        // Cache the token (assuming the token is in the response body)
        var userId = jsonDecode(response.body)['user_id'];
        var bearerToken = jsonDecode(response.body)['logic_token'];

        // Cache the token with 1 day expiration
        await cache.saveData(ENV.CACHE_USER_ID_KEY, userId, const Duration(days: ENV.TOKEN_EXPIRATION_DURATION));
        await cache.saveData(ENV.CACHE_TOKEN_KEY, bearerToken, const Duration(hours: ENV.TOKEN_EXPIRATION_DURATION));

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
      print('Error during sign up: $e');
      //return the unknown error with e as the message
      return '${RESPONSE_MSG['UNKNOWN_ERROR']!}: $e';
    }
  }

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
