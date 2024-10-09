import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/profile.dart';
import 'package:crypto/crypto.dart';

class AuthService {
// For AccountManager:
static String _accountManagerUrl = "grs-accountmanager.azurewebsites.net";
static String _accountManagerDevUrl = "grs-accountmanager-dev.azurewebsites.net";

// For Logic:
static String _logicApiUrl = "grs-logic.azurewebsites.net";
static String _logicApiDevUrl = "grs-logic-dev.azurewebsites.net";

// For DbAccessor:
static String _dbUrl = "grs-dbaccessor.azurewebsites.net";
static String _dbDevUrl = "grs-dbaccessor-dev.azurewebsites.net";

static Map<String, String> _defaultHeaders = {};
//i wanna handle 200

  static bool isSignedIn() {return false;}

  static bool sign(String email, String password){ 

    //take the email and password, send http request
    //if the request is successful, then cache the token
    //and somehow save it in the state too 
    
    return false;
  }

  static Future<bool> signIn(String email, String password) async {
    //sha 256 the password
    //send the email and password to the account manager URL
    //if the response is 200, then cache the token

    //if the response is 401, then return the response

    //if the response is 500, then return the response
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
        return true;
      } else if (response.statusCode == 401) {
        // Unauthorized
        return false;
      } else if (response.statusCode == 500) {
        // Server error
        return false;
      } else {
        // Other response codes
        return false;
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error during sign in: $e');
      return false;
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
