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
}
