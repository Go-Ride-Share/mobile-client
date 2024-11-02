import 'package:http/http.dart' as http;
    
  /// Returns the standard headers
  Map<String, String> getHeaders(String? authorizationToken, String? dbAccessToken, String? userID) {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authorizationToken ?? ''}',
      'X-Db-Token': dbAccessToken ?? '',
      'X-User-ID': userID ?? '',
    };

    return headers;
  }

  /// Makes an Http get request to passed uri with passed headres. Uses passed function to convert the response to a list.
  /// Catches all errors.
  Future<List> sendGetRequestAndGetAsList(List Function(String) convertToList, String uri, Map<String, String> headers) async{
    // Create http request data
    final url = Uri.parse(uri);

    // Make the request and parse the data
    try {
      final response = await http.get(url, headers: headers);
      print('Received response: ${response.statusCode}, ${response.body}');

      // Proccess the response
      if (response.statusCode == 200) {
        // Convert response body to a list of conversations and return
        List conversations = convertToList(response.body);
        return conversations;
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }

    // Error or bad response, return nothing
    return [];
  }