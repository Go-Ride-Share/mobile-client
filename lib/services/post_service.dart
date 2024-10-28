import 'package:go_ride_sharing/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'caching_service.dart';
import '../constants.dart';

class PostService {
  CachingService cache = CachingService();

  late Future<String?> baseAccessToken;
  late Future<String?> dbAccessToken;
  late Future<String?> userID;

  PostService() {
    baseAccessToken = cache.getData(ENV.CACHE_BEARER_TOKEN_KEY);
    dbAccessToken = cache.getData(ENV.CACHE_DB_TOKEN_KEY);
    userID = cache.getData(ENV.CACHE_USER_ID_KEY);
  }

  Future<List<Post>> fetchProfilePosts() async {
    final userId = await userID;
    final logicToken = await baseAccessToken;
    final dbToken = await dbAccessToken;

    final url = Uri.parse('${ENV.API_BASE_URL}/api/GetPosts?userId=$userId');

    // logic token and db token can be null values if they are expired. We are ignoring the case of having to sign in again.
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${logicToken ?? ''}',
      'X-Db-Token': dbToken ?? '',
      'X-User-ID': userId ?? '',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('Data: $data');
        List<Post> posts = (data as List).map((postJson) {
          Post post = Post.fromJson(postJson);
          post.authToken = "dummyAuthToken";
          post.posterName = "dummyPosterName";
          return post;
        }).toList();
        return posts;
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }

    return [];
  }

  Future<void> createPost(Post post) async {
    final postData = jsonEncode({
      'posterId': 'hardcodedDummyValue',
      'originLat': post.startLatitude,
      'originLng': post.startLongitude,
      'destinationLat': post.destinationLatitude,
      'destinationLng': post.destinationLongitude,
      'description': post.description,
      'seatsAvailable': post.seatsAvailable,
      'name': post.postName,
      'departureDate': post.departureDate.toIso8601String(),
      'price': post.price,
    });

    final url = Uri.parse('${ENV.API_BASE_URL}/api/SavePost?userId=${await userID}');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await baseAccessToken ?? ''}',
      'X-Db-Token': await dbAccessToken ?? '',
      'X-User-ID': await userID ?? '',
    };

    // print('Post Data: $postData');

    try {
      final response = await http.post(url, headers: headers, body: postData);

      if (response.statusCode == 201) {
        print('Post created successfully');
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  Future<void> updatePost(Post post) async {
    final postData = jsonEncode({
      'posterId': 'hardcodedDummyValue',
      'postId': post.postId,
      'originLat': post.startLatitude,
      'originLng': post.startLongitude,
      'destinationLat': post.destinationLatitude,
      'destinationLng': post.destinationLongitude,
      'description': post.description,
      'seatsAvailable': post.seatsAvailable,
      'name': post.postName,
      'departureDate': post.departureDate.toIso8601String(),
      'price': post.price,
    });

    final url = Uri.parse('${ENV.API_BASE_URL}/api/SavePost?userId=${await userID}');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await baseAccessToken ?? ''}',
      'X-Db-Token': await dbAccessToken ?? '',
      'X-User-ID': await userID ?? '',
    };

    // print('Post Data: $postData');

    try {
      final response = await http.post(url, headers: headers, body: postData);

      if (response.statusCode == 201) {
        print('Post created successfully');
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  Future<List<Post>> fetchAllPosts() async {
    // Fake JSON string to simulate API response
    final fakeJsonResponse = '''
    [
      {
        "postId": "1",
        "authToken": "dummyAuthToken1",
        "originLat": 40.7128,
        "originLng": -74.0060,
        "destinationLat": 34.0522,
        "destinationLng": -118.2437,
        "description": "Trip from NYC to LA",
        "seatsAvailable": 3,
        "name": "NYC to LA",
        "posterName": "John Doe",
        "departureDate": "2023-10-01T10:00:00Z",
        "price": 100.0
      },
      {
        "postId": "2",
        "authToken": "dummyAuthToken2",
        "originLat": 37.7749,
        "originLng": -122.4194,
        "destinationLat": 47.6062,
        "destinationLng": -122.3321,
        "description": "Trip from SF to Seattle",
        "seatsAvailable": 2,
        "name": "SF to Seattle",
        "posterName": "Jane Smith",
        "departureDate": "2023-10-02T12:00:00Z",
        "price": 150.0
      },
      {
        "postId": "3",
        "authToken": "dummyAuthToken3",
        "originLat": 34.0522,
        "originLng": -118.2437,
        "destinationLat": 36.1699,
        "destinationLng": -115.1398,
        "description": "Trip from LA to Vegas",
        "seatsAvailable": 4,
        "name": "LA to Vegas",
        "posterName": "Alice Johnson",
        "departureDate": "2023-10-03T14:00:00Z",
        "price": 80.0
      },
      {
        "postId": "4",
        "authToken": "dummyAuthToken4",
        "originLat": 36.1699,
        "originLng": -115.1398,
        "destinationLat": 39.7392,
        "destinationLng": -104.9903,
        "description": "Trip from Vegas to Denver",
        "seatsAvailable": 1,
        "name": "Vegas to Denver",
        "posterName": "Bob Brown",
        "departureDate": "2023-10-04T16:00:00Z",
        "price": 120.0
      },
      {
        "postId": "5",
        "authToken": "dummyAuthToken5",
        "originLat": 39.7392,
        "originLng": -104.9903,
        "destinationLat": 41.8781,
        "destinationLng": -87.6298,
        "description": "Trip from Denver to Chicago",
        "seatsAvailable": 2,
        "name": "Denver to Chicago",
        "posterName": "Charlie Davis",
        "departureDate": "2023-10-05T18:00:00Z",
        "price": 200.0
      },
      {
        "postId": "6",
        "authToken": "dummyAuthToken6",
        "originLat": 41.8781,
        "originLng": -87.6298,
        "destinationLat": 40.7128,
        "destinationLng": -74.0060,
        "description": "Trip from Chicago to NYC",
        "seatsAvailable": 3,
        "name": "Chicago to NYC",
        "posterName": "David Evans",
        "departureDate": "2023-10-06T20:00:00Z",
        "price": 250.0
      },
      {
        "postId": "7",
        "authToken": "dummyAuthToken7",
        "originLat": 40.7128,
        "originLng": -74.0060,
        "destinationLat": 42.3601,
        "destinationLng": -71.0589,
        "description": "Trip from NYC to Boston",
        "seatsAvailable": 4,
        "name": "NYC to Boston",
        "posterName": "Eve Foster",
        "departureDate": "2023-10-07T22:00:00Z",
        "price": 90.0
      },
      {
        "postId": "8",
        "authToken": "dummyAuthToken8",
        "originLat": 42.3601,
        "originLng": -71.0589,
        "destinationLat": 43.6591,
        "destinationLng": -70.2568,
        "description": "Trip from Boston to Portland",
        "seatsAvailable": 1,
        "name": "Boston to Portland",
        "posterName": "Frank Green",
        "departureDate": "2023-10-08T08:00:00Z",
        "price": 60.0
      },
      {
        "postId": "9",
        "authToken": "dummyAuthToken9",
        "originLat": 43.6591,
        "originLng": -70.2568,
        "destinationLat": 45.5234,
        "destinationLng": -122.6762,
        "description": "Trip from Portland to Portland",
        "seatsAvailable": 2,
        "name": "Portland to Portland",
        "posterName": "Grace Harris",
        "departureDate": "2023-10-09T10:00:00Z",
        "price": 300.0
      },
      {
        "postId": "10",
        "authToken": "dummyAuthToken10",
        "originLat": 45.5234,
        "originLng": -122.6762,
        "destinationLat": 47.6062,
        "destinationLng": -122.3321,
        "description": "Trip from Portland to Seattle",
        "seatsAvailable": 3,
        "name": "Portland to Seattle",
        "posterName": "Hank Irving",
        "departureDate": "2023-10-10T12:00:00Z",
        "price": 110.0
      }
    ]
    ''';

    try {
      final data = jsonDecode(fakeJsonResponse);
      List<Post> posts = (data as List).map((postJson) {
        return Post.fromJson(postJson);
      }).toList();
      return posts;
    } catch (e) {
      print('Parsing failed: $e');
    }

    return [];
  }
}
